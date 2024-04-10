"use client";

import { useEffect } from "react";
import { useState } from "react";
import HeroImageWeedies from "../public/mint-assets/character line up-temp.png";
import WeediesLogo2 from "../public/mint-assets/weedies-logo-2.png";
import type { NextPage } from "next";
import "react-multi-carousel/lib/styles.css";
import { formatEther } from "viem";
import { AllNfts } from "~~/components/AllNfts";
import { MyCarousel } from "~~/components/MyCarousel";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContract, useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { writeAsync: mint } = useScaffoldContractWrite({ contractName: "YourContract", functionName: "mint" });

  const { data: startMintTimestamp } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintStartTimestamp",
  });

  const { data: endMintTimestamp } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintEndTimestamp",
  });

  const { data: mintPrice, refetch: refetchMintPrice } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintPrice",
  });

  const { data: mintCount, refetch: refetchMintCount } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintCount",
  });

  const { data: maxMintCount, refetch: refetchMaxMintCount } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMaxMintCount",
  });

  const { data: yourContract } = useScaffoldContract({ contractName: "YourContract" });

  const [currentDate, setTime] = useState(Date.now());

  useEffect(() => {
    const interval = setInterval(async () => {
      setTime(Date.now());
    }, 1000);
    return () => {
      clearInterval(interval);
    };
  }, []);

  const mintTimeLeft = (Number(endMintTimestamp) * 1000 || currentDate.valueOf()) - currentDate.valueOf();
  const timeLeftTillMint = Number(startMintTimestamp) * 1000 - currentDate.valueOf();

  const date = new Date(Number(startMintTimestamp) * 1000);
  const endDate = new Date(Number(endMintTimestamp) * 1000);

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

  const mintTimeLeftFormatted = secondsToDhms(mintTimeLeft / 1000);
  const timeLeftTillMintFormatted = secondsToDhms(timeLeftTillMint / 1000);

  let mintWindowOutput;
  if (timeLeftTillMint >= 0) {
    mintWindowOutput = (
      <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
        <p className="grilledCheese text-lg m-0">Mint starts in</p>
        <p className="text-sm m-0 grilledCheese">{timeLeftTillMintFormatted}</p>
      </div>
    );
  } else if (mintTimeLeft >= 0) {
    mintWindowOutput = (
      <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
        <p className="grilledCheese text-lg m-0 text-green-500">Mint ends in</p>
        <p className="grilledCheese text-sm m-0 text-green-500">{mintTimeLeftFormatted}</p>
      </div>
    );
  } else {
    mintWindowOutput = (
      <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
        <p className="grilledCheese text-lg m-0 text-red-500">Mint ended</p>
      </div>
    );
  }

  const supply = Number(maxMintCount) - Number(mintCount);

  return (
    <>
      <div className="flex flex-col items-center justify-center bg-[url('../public/purple.png')] bg-cover">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img alt="Weedies Logo" src={WeediesLogo2.src} className="my-3  w-[373px] lg:w-[810px] " /> {/* */}
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img alt="Hero Image" src={HeroImageWeedies.src} className=" w-[393px] lg:w-[1366px]" /> {/* w-[393px] */}
        {/* <img src={HeroImageCharacter.src} className="h-96" /> */}
      </div>
      <p className="grilledCheese text-xl text-center lg:text-8xl">
        Nounies are Dreamers, Rebels, Creators, Artists, and Friends living their best life on the blockchain.
      </p>

      <div className="flex items-center flex-col flex-grow pt-10 bg-base-100">
        <MyCarousel />

        <div className="flex items-center justify-center text-center">
          <p className="grilledCheese text-2xl">Swipe around, find out.</p>
        </div>

        <div className="flex flex-col items-center justify-center text-center">
          <p className="grilledCheese text-4xl">Mint a Weedie</p>
        </div>

        <div className="flex flex-wrap justify-center">
          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 m-1">
            <p className="grilledCheese text-lg m-0">Contract Address</p>
            <Address address={yourContract?.address} />
          </div>
          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
            <p className="grilledCheese text-lg m-0">Mint Price</p>
            <p className="text-md m-0 grilledCheese">{formatEther(mintPrice || BigInt(0)).toString()}</p>
          </div>

          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
            <p className="grilledCheese text-lg m-0">Supply</p>
            <p className={`text-md m-0 grilledCheese ${supply === 0 ? "text-red-500" : ""}`}>{supply}</p>
          </div>
        </div>
        <div className="flex flex-wrap justify-center">
          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
            <p className="text-lg m-0 grilledCheese">Starts</p>
            <p className="text-sm m-0 grilledCheese">{startDateLocale}</p>
          </div>
          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
            <p className="grilledCheese text-lg m-0">Ends</p>
            <p className="text-sm m-0 grilledCheese">{endDateLocale}</p>
          </div>
          {mintWindowOutput}
        </div>

        <div className="flex flex-col items-center justify-center text-center">
          <p className="grilledCheese text-4xl">{"Lick the paper, twist it up, and mint yourself a Weedie!"}</p>
        </div>

        <button
          onClick={async () => {
            await mint({ value: mintPrice });
            await refetchMintPrice();
            await refetchMintCount();
            await refetchMaxMintCount();
          }}
          className="insanibc btn btn-secondary btn-lg m-1 text-3xl mb-10"
        >
          {"Let's toke it!"}
        </button>
        {<AllNfts />}
      </div>
    </>
  );
};

export default Home;
