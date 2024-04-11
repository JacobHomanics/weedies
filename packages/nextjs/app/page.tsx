"use client";

import { useEffect } from "react";
import { useState } from "react";
import dynamic from "next/dynamic";
import hero from "../public/hero.png";
import type { NextPage } from "next";
import "react-multi-carousel/lib/styles.css";
import { useFetch } from "usehooks-ts";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
import { HeartIcon } from "@heroicons/react/24/outline";
// import Carousel from "~~/components/Carousel";
// import { AllNfts } from "~~/components/AllNfts";
// import { MyCarousel } from "~~/components/Carousel";
import { NftCard } from "~~/components/NftCard";
import { Address } from "~~/components/scaffold-eth";
import {
  useScaffoldContract,
  useScaffoldContractRead,
  useScaffoldContractWrite,
  useScaffoldEventSubscriber,
} from "~~/hooks/scaffold-eth";
import bagOfWeed from "~~/public/weed-bag.png";

const DynamicCarousel = dynamic(() => import("../components/Carousel"), {
  loading: () => <p>Loading...</p>,
  ssr: false,
});

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();

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
  // const endDate = new Date(Number(endMintTimestamp) * 1000);

  const startDateLocale = date.toLocaleString("en-US", {
    day: "2-digit",
    month: "2-digit",
    year: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });

  // const endDateLocale = endDate.toLocaleString("en-US", {
  //   day: "2-digit",
  //   month: "2-digit",
  //   year: "2-digit",
  //   hour: "2-digit",
  //   minute: "2-digit",
  // });

  // function secondsToDhms2(seconds: number) {
  //   seconds = Number(seconds);
  //   const d = Math.floor(seconds / (3600 * 24));
  //   const h = Math.floor((seconds % (3600 * 24)) / 3600);
  //   const m = Math.floor((seconds % 3600) / 60);
  //   const s = Math.floor(seconds % 60);

  //   const dDisplay = d > 0 ? d + (d == 1 ? " : " : " : ") : "";
  //   const hDisplay = h > 0 ? h + (h == 1 ? " : " : " : ") : "";
  //   const mDisplay = m > 0 ? m + (m == 1 ? " : " : " : ") : "";
  //   const sDisplay = s > 0 ? s + (s == 1 ? "" : "") : "";
  //   return (dDisplay + hDisplay + mDisplay + sDisplay).replace(/,\s*$/, "");
  // }

  // function secondsToDhms(seconds: number) {
  //   seconds = Number(seconds);
  //   const d = Math.floor(seconds / (3600 * 24));
  //   const h = Math.floor((seconds % (3600 * 24)) / 3600);
  //   const m = Math.floor((seconds % 3600) / 60);
  //   const s = Math.floor(seconds % 60);

  //   const dDisplay = d > 0 ? d + (d == 1 ? " day, " : " days, ") : "";
  //   const hDisplay = h > 0 ? h + (h == 1 ? " hour, " : " hours, ") : "";
  //   const mDisplay = m > 0 ? m + (m == 1 ? " minute, " : " minutes, ") : "";
  //   const sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : "";
  //   return (dDisplay + hDisplay + mDisplay + sDisplay).replace(/,\s*$/, "");
  // }

  // let mintTimeLeftFormatted = secondsToDhms2(mintTimeLeft / 1000);

  const aDate = new Date(0);
  aDate.setSeconds(mintTimeLeft / 1000); // specify value for SECONDS here
  const mintTimeLeftFormatted = aDate.toISOString().substring(11, 19);

  // const timeLeftTillMintFormatted = secondsToDhms(timeLeftTillMint / 1000);

  let mintWindowOutput;
  if (timeLeftTillMint >= 0) {
    mintWindowOutput = (
      <div className="flex flex-col text-center  rounded-lg p-2 w-40 m-1">
        <p className="grilledCheese text-md lg:text-4xl m-0 text-green-500 -m-1">Starts</p>
        <p className="text-md lg:text-4xl m-0 text-red-600 -m-1">{startDateLocale}</p>
      </div>
    );
  } else if (mintTimeLeft >= 0) {
    mintWindowOutput = (
      <div className="flex flex-col text-center bg-base-100 rounded-lg p-0 lg:p-2 w-40 lg:w-80 m-1">
        <p className="grilledCheese text-md lg:text-4xl m-0 text-green-500 -m-1">Mint Time Left</p>
        <p className="text-md lg:text-4xl m-0 text-red-600 -m-1">{mintTimeLeftFormatted}</p>
      </div>
    );
  } else {
    mintWindowOutput = (
      <div className="flex flex-col text-center rounded-lg p-2 w-40 m-1">
        <p className="grilledCheese text-lg m-0 text-red-600">Mint ended</p>
      </div>
    );
  }

  const supply = Number(maxMintCount) - Number(mintCount);

  const [mintedTokenId, setMintedTokenId] = useState<bigint>();

  const { data: mintedTokenURI } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "tokenURI",
    args: [mintedTokenId],
  });

  const response = useFetch<any>(mintedTokenURI?.replace("https://nft.bueno.art", "https://app.bueno.art"));
  if (response.data !== undefined)
    response.data.image = response?.data?.image?.replace("https://nft.bueno.art", "https://app.bueno.art");

  useScaffoldEventSubscriber({
    contractName: "YourContract",
    eventName: "Minted",
    listener: logs => {
      logs.map(log => {
        const { user, tokenId } = log.args;
        if (user === connectedAddress) {
          setMintedTokenId(tokenId);
        }
      });
    },
  });

  return (
    <>
      {/* <MyCarousel /> */}

      {/* <MyCarousel /> */}

      <div className="flex items-center flex-col flex-grow bg-base-100">
        <div className="relative">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={hero.src} alt="Test" className="w-[400px] lg:w-[1051px] lg:h-[670px] lg:mb-4" />{" "}
          {/* 1366px x 870px*/}
          <div className="flex flex-wrap justify-center w-[300px] absolute lg:inset-0 lg:h-[100px] left-[135px] lg:left-[600px] top-[60px] lg:top-[150px]">
            {mintWindowOutput}
          </div>
        </div>
        {/* <div className="flex flex-col items-center justify-center bg-[url('../public/purple.png')] bg-cover"> */}
        {/* eslint-disable-next-line @next/next/no-img-element */}
        {/* <img alt="Weedies Logo" src={WeediesLogo2.src} className="my-3  w-[373px] lg:w-[810px] " />  */}
        {/* eslint-disable-next-line @next/next/no-img-element */}
        {/* <img alt="Hero Image" src={HeroImageWeedies.src} className=" w-[393px] lg:w-[1366px]" /> */}
        {/* <img src={HeroImageCharacter.src} className="h-96" /> */}
        {/* </div> */}
        <p className="grilledCheese text-xl text-center lg:text-4xl m-4 lg:mb-10">
          <span className="text-red-600">24,420</span> toasted, fun-loving weirdos living their best life, one toke at a
          time!
        </p>
        <p className="grilledCheese text-2xl text-secondary lg:text-4xl">Tasty Samples</p>
        <DynamicCarousel />
        {/* <Carousel /> */}
        <p className="grilledCheese text-2xl lg:text-4xl">Twist one up!</p>
        {/* <div className="flex flex-col items-center justify-center text-center">
          <p className="grilledCheese text-4xl">{"Lick the paper, twist it up, and mint yourself a Weedie!"}</p>
        </div> */}

        {response.data !== undefined ? (
          <>
            {/* <CardMinted image={response.data.image} title={response.data.name} />{" "} */}

            <NftCard data={response.data} imgSrc={response.data.image} />
          </>
        ) : (
          <NftCard data={response.data} imgSrc={bagOfWeed.src} />
        )}

        <button
          onClick={async () => {
            await mint({ value: mintPrice });
            await refetchMintPrice();
            await refetchMintCount();
            await refetchMaxMintCount();
          }}
          className="insanibc btn btn-secondary btn-lg text-3xl mt-5"
        >
          {"Let's toke it!"}
        </button>
        <p className="m-0 mb-10">*Mint Token</p>
        <button
          onClick={async () => {
            await mint({ value: mintPrice });
            await refetchMintPrice();
            await refetchMintCount();
            await refetchMaxMintCount();
          }}
          className="insanibc btn btn-secondary btn-lg m-1 text-3xl mb-10"
        >
          {"Let's toke (mint) it!"}
        </button>

        {/* {<AllNfts />} */}
        <div className="flex flex-wrap justify-center">
          <div className="flex flex-col text-center  border-secondary border-4 rounded-lg p-2 w-32 lg:w-72 m-1">
            <p className="grilledCheese text-md m-0 lg:text-4xl">Mint Price</p>
            <p className="text-md m-0 grilledCheese lg:text-4xl">{formatEther(mintPrice || BigInt(0)).toString()}</p>
          </div>

          <div className="flex flex-col text-center border-secondary border-4 rounded-lg p-2 w-32 lg:w-72 m-1">
            <p className="grilledCheese text-md m-0 lg:text-4xl">Supply</p>
            <p className={`text-md m-0 grilledCheese lg:text-4xl ${supply === 0 ? "text-red-600" : "text-green-500"}`}>
              {supply.toString()}
            </p>
          </div>

          <div className="flex flex-col text-center border-secondary border-4 rounded-lg p-2 w-32 lg:w-72 m-1">
            <p className="grilledCheese text-md m-0 lg:text-4xl">Contract</p>
            <div className="flex items-center justify-center">
              <Address address={yourContract?.address} size="xs" />
            </div>
          </div>
        </div>
        <button
          onClick={async () => {
            await mint({ value: mintPrice });
            await refetchMintPrice();
            await refetchMintCount();
            await refetchMaxMintCount();
          }}
          className="insanibc btn-lg bg-violet-800  hover:bg-blue-500 text-white-700 font-semibold hover:text-white py-2 text-4xl m-10"
        >
          {"MERCH"}
        </button>
        <div className="flex justify-center items-center gap-2 mb-4  mt-10">
          <p className="m-0 text-center">
            Built with <HeartIcon className="inline-block h-4 w-4" /> at
          </p>
          <a
            className="flex justify-center items-center gap-1"
            href="https://www.bigshot.wtf/"
            target="_blank"
            rel="noreferrer"
          >
            {/* <BuidlGuidlLogo className="w-3 h-5 pb-1" /> */}
            <span className="link text-red-600">Bigshot.wtf</span>
          </a>
        </div>
      </div>
    </>
  );
};

export default Home;
