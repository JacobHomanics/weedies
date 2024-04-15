"use client";

type Props = {
  data?: any;
  imgSrc: any;
  attributes?: any;
};

export const NftCard = ({ data, imgSrc, attributes }: Props) => {
  // let output;

  // if (data?.image) {
  //   output = (

  //   );
  // }

  let allAttributes = [];

  if (attributes) {
    allAttributes = attributes.map((attribute: any, index: number) => {
      return (
        <div key={index} className="flex space-x-2 bg-[#033900] rounded-lg p-1">
          <p className="text-xs text-yellow-500">{attribute["trait_type"]}:</p>
          <p className="text-xs">{attribute["value"]}</p>
        </div>
      );
    });
  }

  return (
    <>
      <div className="w-[275px] lg:w-[350px] flex flex-col items-center justify-center m-1 rounded-2xl">
        {imgSrc ? (
          <>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={imgSrc} alt="Alt" className="m-2 rounded-lg" />
            <p className="font-bold text-center text-xl m-0">{data?.name}</p>
            <div className="flex flex-wrap space-x-2 space-y-1 items-center justify-center">{allAttributes}</div>
          </>
        ) : (
          <>
            <div className="w-[184px] h-[184px] lg:w-[184px] lg:h-[184px] m-2 rounded-lg"></div>
          </>
        )}
      </div>
    </>
  );
};
