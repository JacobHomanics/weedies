"use client";

import { useCallback, useEffect } from "react";
import { useMemo } from "react";
import { useState } from "react";
import type { NextPage } from "next";
import { formatEther } from "viem";
// import { useAccount } from "wagmi";
import { useBalance } from "wagmi";
import { NftCard } from "~~/components/NftCard";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContract, useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

function useTokenIds(numOfTokens: number) {
  const refetch = useCallback(() => {
    const tokenIds: bigint[] = [];

    if (numOfTokens) {
      for (let i = 1; i <= numOfTokens; i++) {
        tokenIds.push(BigInt(i));
      }
    }

    console.log(tokenIds);
    return { tokenIds };
  }, [numOfTokens]);

  const { tokenIds } = useMemo(() => {
    const { tokenIds } = refetch();
    // const tokenIds: bigint[] = [];

    // if (numOfTokens) {
    //   for (let i = 1; i <= numOfTokens; i++) {
    //     tokenIds.push(BigInt(i));
    //   }
    // }

    return { tokenIds, refetch };
  }, [refetch]);

  return { tokenIds, refetch };
}

function useUris(contract: any, tokenIds: bigint[]) {
  const [uris, setUris] = useState<string[]>([]);

  const refetch = useCallback(async () => {
    if (!contract) return;

    const arr = [];
    for (let i = 0; i < tokenIds.length; i++) {
      const result = await contract.read.tokenURI([tokenIds[i]]);
      arr.push(result);
    }

    setUris([...arr]);
  }, [contract?.address, tokenIds, uris.length]);

  useEffect(() => {
    async function get() {
      await refetch();
    }

    get();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [contract?.address, tokenIds, uris.length, refetch]);

  return { uris, setUris, refetch };
}

function useFetches(uris: string[]) {
  const [responses, setResponses] = useState<any[]>([]);

  const refetch = useCallback(async () => {
    const arr = [];
    for (let i = 0; i < uris.length; i++) {
      const response = await fetch(uris[i]);
      const responseJson = await response.json();
      arr.push(responseJson);
    }

    setResponses([...arr]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [uris.length]);

  useEffect(() => {
    async function get() {
      await refetch();
    }

    get();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [uris.length, refetch]);

  return { responses, refetch };
}

const Home: NextPage = () => {
  // const { address: connectedAddress } = useAccount();
  const { writeAsync: mint } = useScaffoldContractWrite({ contractName: "YourContract", functionName: "mint" });
  const { writeAsync: withdraw } = useScaffoldContractWrite({ contractName: "YourContract", functionName: "withdraw" });
  const { writeAsync: startMint } = useScaffoldContractWrite({
    contractName: "YourContract",
    functionName: "startMint",
  });

  const { data: mintCount, refetch: refetchMintCount } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintCount",
  });

  const { data: startMintTimestamp, refetch: refetchStartMintTimestamp } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getStartMintTimestamp",
  });

  const { data: isMintStarted, refetch: refetchIsMintStarted } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getIsMintStarted",
  });

  const { data: mintDuration, refetch: refetchGetWindow } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintDuration",
  });

  const { data: maxMintCount } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMaxMintCount",
  });

  const { data: tokenName } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "name",
  });

  const { data: tokenSymbol } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "symbol",
  });

  const { data: royaltyRecipient } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getRoyaltyRecipient",
  });

  const { data: activeThreshold, refetch: refetchActiveThrehsold } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getAcitveMintingThreshold",
  });

  const { data: yourContract } = useScaffoldContract({ contractName: "YourContract" });
  const { data: balance, refetch: refetchBalance } = useBalance({ address: yourContract?.address });

  const { tokenIds, refetch: refetchTokenIds } = useTokenIds(Number(mintCount));

  const { uris, refetch: refetchUris } = useUris(yourContract, tokenIds);

  for (let i = 0; i < uris.length; i++) {
    uris[i] = uris[i].replace("https://nft.bueno.art", "https://app.bueno.art");
  }

  const { responses, refetch: refetchResponses } = useFetches(uris);

  const allNfts = responses.map((response, index) => {
    return <NftCard key={index} data={response} />;
  });

  const date = new Date(Number(startMintTimestamp) * 1000);
  const endDate = new Date((startMintTimestamp && mintDuration ? Number(startMintTimestamp + mintDuration) : 0) * 1000);

  const startDateLocale = date.toLocaleString("en-US", {
    day: "2-digit",
    month: "2-digit",
    year: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });

  const endDateLocale = endDate.toLocaleString("en-US", {
    day: "2-digit",
    month: "2-digit",
    year: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });

  function secondsToDhms(seconds: number) {
    seconds = Number(seconds);
    const d = Math.floor(seconds / (3600 * 24));
    const h = Math.floor((seconds % (3600 * 24)) / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = Math.floor(seconds % 60);

    const dDisplay = d > 0 ? d + (d == 1 ? " day, " : " days, ") : "";
    const hDisplay = h > 0 ? h + (h == 1 ? " hour, " : " hours, ") : "";
    const mDisplay = m > 0 ? m + (m == 1 ? " minute, " : " minutes, ") : "";
    const sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : "";
    return (dDisplay + hDisplay + mDisplay + sDisplay).replace(/,\s*$/, "");
  }

  const mintDurationFormatted = secondsToDhms(Number(mintDuration));

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10 bg-base-100">
        <div className="px-5 items-center text-center">
          <button
            onClick={async () => {
              await startMint();
              await refetchMintCount();
              await refetchActiveThrehsold();
              await refetchBalance();
              await refetchTokenIds();
              await refetchUris();
              await refetchResponses();
              await refetchIsMintStarted();
              await refetchGetWindow();
            }}
            className="btn btn-secondary btn-sm"
          >
            Start Mint
          </button>

          <button
            onClick={async () => {
              await mint({ value: activeThreshold?.mintPrice });
              await refetchMintCount();
              await refetchActiveThrehsold();
              await refetchBalance();
              await refetchTokenIds();
              await refetchUris();
              await refetchResponses();
              await refetchStartMintTimestamp();
              await refetchIsMintStarted();
              await refetchGetWindow();
            }}
            className="btn btn-secondary btn-sm"
          >
            Mint
          </button>

          <button
            onClick={async () => {
              await withdraw();
              await refetchMintCount();
              await refetchActiveThrehsold();
              await refetchBalance();
              await refetchTokenIds();
              await refetchUris();
              await refetchResponses();
              await refetchStartMintTimestamp();
            }}
            className="btn btn-secondary btn-sm"
          >
            Withdraw
          </button>

          <div className="flex flex-col items-center mt-5">
            <div className="bg-base-300 rounded-lg p-1 m-1">
              {tokenName} ({tokenSymbol})
            </div>
          </div>
          <div className="flex flex-wrap justify-center space-x-10">
            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Max Mint Count: {maxMintCount?.toString()}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Is Mint Started: {isMintStarted?.toString()}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Is Mint Active: {isMintStarted && (endDate.getTime() > new Date().getTime())?.toString()}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Mint Duration: {mintDurationFormatted?.toString()}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Mint Start Date: {" " + startDateLocale}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p> Mint End Date: {" " + endDateLocale}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Mint Count: {mintCount?.toString()}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Mint Price: {formatEther(activeThreshold?.mintPrice || BigInt(0)).toString()}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>Min Threshold Mint Count: {activeThreshold?.minThreshold.toString()}</p>
            </div>
            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p className="truncate">Max Threshold Mint Count: {activeThreshold?.maxThreshold.toString()}</p>
            </div>

            <div className="bg-base-300 rounded-lg p-1 m-1">
              <p>YourContract Balance: {balance?.formatted.toString() || "0"}</p>
            </div>

            <div className="flex flex-col items-center justify-center bg-base-300 rounded-lg p-1 m-1">
              <p>Royalty Recipient: </p>
              <Address address={royaltyRecipient}></Address>
            </div>
          </div>

          <p className="text-center text-2xl">All Weedies</p>
          <div className="flex flex-wrap justify-center bg-base-100 rounded-lg m-4">{allNfts}</div>
        </div>
      </div>
    </>
  );
};

export default Home;
