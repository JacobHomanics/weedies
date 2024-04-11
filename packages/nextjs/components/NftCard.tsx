"use client";

type Props = {
  data: any;
  imgSrc: any;
};

export const NftCard = ({ data, imgSrc }: Props) => {
  // let output;

  // if (data?.image) {
  //   output = (

  //   );
  // }

  return (
    <>
      <div className="w-[275px] lg:w-[350px] flex flex-col items-center justify-center m-1 rounded-2xl">
        {imgSrc ? (
          <>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={imgSrc} alt="Alt" className="m-2 rounded-lg" />
            <p className="font-bold text-center text-xl">{data?.name}</p>
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
