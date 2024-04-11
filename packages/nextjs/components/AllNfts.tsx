// "use client";

// import { useCallback, useEffect, useMemo, useState } from "react";
// import { NftCard } from "./NftCard";
// import { useScaffoldContract, useScaffoldContractRead } from "~~/hooks/scaffold-eth";

// function useTokenIds(numOfTokens: number) {
//   const refetch = useCallback(() => {
//     const tokenIds: bigint[] = [];

//     if (numOfTokens) {
//       for (let i = 1; i <= numOfTokens; i++) {
//         tokenIds.push(BigInt(i));
//       }
//     }

//     return { tokenIds };
//   }, [numOfTokens]);

//   const { tokenIds } = useMemo(() => {
//     const { tokenIds } = refetch();
//     return { tokenIds, refetch };
//   }, [refetch]);

//   return { tokenIds, refetch };
// }

// function useFetches(uris: string[]) {
//   const [responses, setResponses] = useState<any[]>([]);

//   const refetch = useCallback(async () => {
//     const arr = [];
//     for (let i = 0; i < uris.length; i++) {
//       const response = await fetch(uris[i]);
//       const responseJson = await response.json();
//       arr.push(responseJson);
//     }

//     setResponses([...arr]);
//     // eslint-disable-next-line react-hooks/exhaustive-deps
//   }, [uris.length]);

//   useEffect(() => {
//     async function get() {
//       await refetch();
//     }

//     get();
//     // eslint-disable-next-line react-hooks/exhaustive-deps
//   }, [uris.length, refetch]);

//   return { responses, refetch };
// }

// function useUris(contract: any, tokenIds: bigint[]) {
//   const [uris, setUris] = useState<string[]>([]);

//   const refetch = useCallback(async () => {
//     if (!contract) return;

//     const arr = [];
//     for (let i = 0; i < tokenIds.length; i++) {
//       const result = await contract.read.tokenURI([tokenIds[i]]);
//       arr.push(result);
//     }

//     setUris([...arr]);
//     // eslint-disable-next-line react-hooks/exhaustive-deps
//   }, [contract?.address, tokenIds, uris.length]);

//   useEffect(() => {
//     async function get() {
//       await refetch();
//     }

//     get();
//     // eslint-disable-next-line react-hooks/exhaustive-deps
//   }, [contract?.address, tokenIds, uris.length, refetch]);

//   return { uris, setUris, refetch };
// }

// export const AllNfts = () => {
//   const { data: mintCount } = useScaffoldContractRead({
//     contractName: "YourContract",
//     functionName: "getMintCount",
//   });

//   const { tokenIds } = useTokenIds(Number(mintCount));

//   const { data: yourContract } = useScaffoldContract({ contractName: "YourContract" });

//   const { uris } = useUris(yourContract, tokenIds);

//   for (let i = 0; i < uris.length; i++) {
//     uris[i] = uris[i].replace("https://nft.bueno.art", "https://app.bueno.art");
//   }

//   const { responses } = useFetches(uris);

//   const allNfts = responses.map((response, index) => {
//     return <NftCard key={index} data={response} />;
//   });

//   return (
//     <>
//       <div>
//         <p className="text-center text-2xl">All Weedies</p>
//         <div className="flex flex-wrap justify-center bg-base-100 rounded-lg m-4">{allNfts}</div>
//       </div>
//     </>
//   );
// };
