"use client";

import { useCallback, useEffect } from "react";
import { useMemo } from "react";
import { useState } from "react";
import nounie1 from "../public/carousel/1.png";
import nounie2 from "../public/carousel/2.png";
import nounie3 from "../public/carousel/3.png";
import nounie4 from "../public/carousel/4.png";
// import WeediesLogo from "../public/mint-assets/Weedies Logo.png";
import WeediesLogo2 from "../public/mint-assets/Weedies logo-810px.png";
import HeroImageWeedies from "../public/mint-assets/character line up-temp.png";
// import nounie5 from "../public/carousel/5.png";
// import HeroImageCharacter from "../public/weedies-samples/Hero-Image-characters.png";
// import NouniesLogo from "../public/weedies-samples/Nounies_logo.png";
import type { NextPage } from "next";
import Carousel from "react-multi-carousel";
import "react-multi-carousel/lib/styles.css";
import { useFetch } from "usehooks-ts";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
// import { useBalance } from "wagmi";
import { NftCard } from "~~/components/NftCard";
// import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContract, useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

function useTokenIds(numOfTokens: number) {
  const refetch = useCallback(() => {
    const tokenIds: bigint[] = [];

    if (numOfTokens) {
      for (let i = 1; i <= numOfTokens; i++) {
        tokenIds.push(BigInt(i));
      }
    }

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
    // eslint-disable-next-line react-hooks/exhaustive-deps
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
  const { address: connectedAddress } = useAccount();
  const { writeAsync: mint } = useScaffoldContractWrite({ contractName: "YourContract", functionName: "mint" });
  const { writeAsync: rollOneUp } = useScaffoldContractWrite({
    contractName: "YourContract",
    functionName: "rollOneUp",
  });
  // const { writeAsync: withdraw } = useScaffoldContractWrite({ contractName: "YourContract", functionName: "withdraw" });
  // const { writeAsync: startMint } = useScaffoldContractWrite({
  //   contractName: "YourContract",
  //   functionName: "startMint",
  // });

  const { data: mintCount, refetch: refetchMintCount } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintCount",
  });

  const { data: startMintTimestamp } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintStartTimestamp",
  });

  const { data: endMintTimestamp } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintEndTimestamp",
  });

  // const { data: isMintStarted, refetch: refetchIsMintStarted } = useScaffoldContractRead({
  //   contractName: "YourContract",
  //   functionName: "getIsMintStarted",
  // });

  // const { data: mintDuration, refetch: refetchGetWindow } = useScaffoldContractRead({
  //   contractName: "YourContract",
  //   functionName: "getMintDuration",
  // });

  // const { data: maxMintCount } = useScaffoldContractRead({
  //   contractName: "YourContract",
  //   functionName: "getMaxMintCount",
  // });

  // const { data: tokenName } = useScaffoldContractRead({
  //   contractName: "YourContract",
  //   functionName: "name",
  // });

  // const { data: tokenSymbol } = useScaffoldContractRead({
  //   contractName: "YourContract",
  //   functionName: "symbol",
  // });

  // const { data: royaltyRecipient } = useScaffoldContractRead({
  //   contractName: "YourContract",
  //   functionName: "getRoyaltyRecipient",
  // });

  const { data: mintPrice, refetch: refetchMintPrice } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getMintPrice",
  });

  // const { data: activeThreshold, refetch: refetchActiveThrehsold } = useScaffoldContractRead({
  //   contractName: "YourContract",
  //   functionName: "getAcitveMintingThreshold",
  // });

  const { data: yourContract } = useScaffoldContract({ contractName: "YourContract" });
  // const { data: balance, refetch: refetchBalance } = useBalance({ address: yourContract?.address });

  const { tokenIds, refetch: refetchTokenIds } = useTokenIds(Number(mintCount));

  const { uris } = useUris(yourContract, tokenIds);

  for (let i = 0; i < uris.length; i++) {
    uris[i] = uris[i].replace("https://nft.bueno.art", "https://app.bueno.art");
  }

  const {
    data: pregenTokenURI,
    refetch: refetchPregen,
    error,
  } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "getRolledTokenURI",
    args: [connectedAddress],
  });

  const pregenTokenURIFormatted = pregenTokenURI?.replace("https://nft.bueno.art", "https://app.bueno.art");

  const res = useFetch(pregenTokenURIFormatted);

  const response = error === null ? res : undefined;

  const { responses } = useFetches(uris);

  const allNfts = responses.map((response, index) => {
    return <NftCard key={index} data={response} />;
  });

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
  // const endDate = new Date((startMintTimestamp && mintDuration ? Number(startMintTimestamp + mintDuration) : 0) * 1000);

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

  // const mintDurationFormatted = secondsToDhms(Number(mintDuration));

  const carouselImgClassName = "border-2 border-secondary";

  let mintWindowOutput;
  if (timeLeftTillMint >= 0) {
    mintWindowOutput = (
      <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
        <p className="insanibc text-lg m-0">Mint starts in</p>
        <p className="text-sm m-0 insanibc">{timeLeftTillMintFormatted}</p>
      </div>
    );
  } else if (mintTimeLeft >= 0) {
    mintWindowOutput = (
      <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
        <p className="insanibc text-lg m-0 text-green-500">Mint ends in</p>
        <p className="insanibc text-sm m-0 text-green-500">{mintTimeLeftFormatted}</p>
      </div>
    );
  } else {
    mintWindowOutput = (
      <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
        <p className="insanibc text-lg m-0 text-red-500">Mint ended</p>
      </div>
    );
  }

  return (
    <>
      <div className="flex flex-col items-center justify-center bg-[url('../public/purple.png')] bg-cover">
        <img src={WeediesLogo2.src} className="my-3  w-[373px] lg:w-[810px] " /> {/* */}
        <img src={HeroImageWeedies.src} className=" w-[393px] lg:w-[1366px]" /> {/* w-[393px] */}
        {/* <img src={HeroImageCharacter.src} className="h-96" /> */}
      </div>
      <p className="insanibc text-xl text-center lg:text-8xl">
        Nounies are Dreamers, Rebels, Creators, Artists, and Friends living their best life on the blockchain.
      </p>

      <div className="relative">
        {/* <img src={NouniesLogo.src} className="absolute inset-y-5" /> */}
        {/* <img src={WeediesLogo2.src} className="absolute inset-y-5 left-[300px]" /> */}
        {/* <img src={WeediesLogo.src} className="absolute inset-y-5" /> */}

        {/* <img src={HeroImageCharacter.src} /> */}
      </div>
      {/* <div className="flex items-center justify-center text-center">
        <p className="grilledCheese text-xl w-80 -mt-20 lg:text-6xl lg:w-7/12 lg:-mt-60">
          Nounies are Dreamers, Rebels, Creators, Artists, and Friends living their best life on the blockchain.
        </p>
      </div> */}

      <div className="flex items-center flex-col flex-grow pt-10 bg-base-100">
        <Carousel
          additionalTransfrom={0}
          arrows
          autoPlay
          autoPlaySpeed={1000}
          centerMode
          className=""
          containerClass="container"
          dotListClass=""
          draggable
          focusOnSelect={false}
          infinite
          itemClass=""
          keyBoardControl
          minimumTouchDrag={80}
          pauseOnHover
          renderArrowsWhenDisabled={false}
          renderButtonGroupOutside={false}
          renderDotsOutside={false}
          responsive={{
            desktop: {
              breakpoint: {
                max: 3000,
                min: 1024,
              },
              items: 1,
              partialVisibilityGutter: 30,
            },
            mobile: {
              breakpoint: {
                max: 464,
                min: 0,
              },
              items: 1,
              partialVisibilityGutter: 20,
            },
            tablet: {
              breakpoint: {
                max: 1024,
                min: 464,
              },
              items: 1,
              partialVisibilityGutter: 20,
            },
          }}
          rewind={false}
          rewindWithAnimation={false}
          rtl={false}
          shouldResetAutoplay
          showDots={false}
          sliderClass=""
          slidesToSlide={1}
          swipeable
        >
          <div className="m-10">
            <img src={nounie1.src} alt="Fruits" className={carouselImgClassName} />
          </div>

          <div className="m-10">
            <img src={nounie2.src} alt="Fruits" className={carouselImgClassName} />
          </div>

          <div className="m-10">
            <img src={nounie3.src} alt="Fruits" className={carouselImgClassName} />
          </div>

          <div className="m-10">
            <img src={nounie4.src} alt="Fruits" className={carouselImgClassName} />
          </div>
        </Carousel>
        <div className="flex items-center justify-center text-center">
          <p className="insanibc text-2xl">Swipe around, find out.</p>
        </div>

        <div className="flex flex-col items-center justify-center text-center">
          <p className="insanibc text-4xl">Mint a Weedie</p>
        </div>

        <div className="flex flex-wrap justify-center">
          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
            <p className="insanibc text-lg m-0">Mint Price</p>
            <p className="text-md m-0 insanibc">{formatEther(mintPrice || BigInt(0)).toString()}</p>
          </div>
        </div>
        <div className="flex flex-wrap justify-center">
          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
            <p className="text-lg m-0 insanibc">Starts</p>
            <p className="text-sm m-0 insanibc">{startDateLocale}</p>
          </div>
          <div className="flex flex-col text-center bg-base-200 rounded-lg p-2 w-40 m-1">
            <p className="insanibc text-lg m-0">Ends</p>
            <p className="text-sm m-0 insanibc">{endDateLocale}</p>
          </div>
          {mintWindowOutput}
        </div>

        <div className="flex flex-col items-center justify-center text-center">
          <p className="insanibc text-xl">
            {"First, roll up a weedie. If you don't like how it looks, then you can re-roll it!"}
          </p>
        </div>

        <NftCard data={response?.data} />

        <button
          onClick={async () => {
            await rollOneUp();
            // await mint({ value: activeThreshold?.mintPrice });
            await refetchMintCount();
            // await refetchActiveThrehsold();
            await refetchPregen();
            await refetchMintPrice();
            // await refetchBalance();
            await refetchTokenIds();
            // await refetchUris();
            // await refetchResponses();
            // await refetchStartMintTimestamp();
            // await refetchIsMintStarted();
            // await refetchGetWindow();
          }}
          className="insanibc btn btn-secondary btn-lg m-1 text-3xl shadow-[0_35px_60px_-15px_rgba(0,0,0,0.3)]"
        >
          Twist one up
        </button>

        <div className="flex flex-col items-center justify-center text-center">
          <p className="font-nouns font-black text-xl">
            {
              "Finally, if you're satisfied with your roll job, then lick the paper, twist 'em up, and mint yourself a Weedie!"
            }
          </p>
        </div>

        <button
          onClick={async () => {
            await mint({ value: mintPrice });
            await refetchMintCount();
            // await refetchActiveThrehsold();
            // await refetchBalance();
            await refetchTokenIds();
            // await refetchUris();
            await refetchPregen();
            await refetchMintPrice();

            // await refetchResponses();
            // await refetchStartMintTimestamp();
            // await refetchIsMintStarted();
            // await refetchGetWindow();
          }}
          className="insanibc btn btn-secondary btn-lg m-1 text-3xl mb-10"
        >
          {"I'll toke it!"}
        </button>

        {/* <button
          onClick={async () => {
            await startMint();
            await refetchMintCount();
            await refetchActiveThrehsold();
            // await refetchBalance();
            await refetchPregen();

            await refetchTokenIds();
            await refetchUris();
            // await refetchResponses();
            // await refetchIsMintStarted();
            await refetchGetWindow();
          }}
          className="btn btn-secondary btn-sm"
        >
          Start Mint
        </button> */}

        {/*

        <div className="flex flex-col items-center justify-center text-center"></div>

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
*/}
        <p className="text-center text-2xl">All Weedies</p>
        <div className="flex flex-wrap justify-center bg-base-100 rounded-lg m-4">{allNfts}</div>
      </div>
    </>
  );
};

export default Home;
