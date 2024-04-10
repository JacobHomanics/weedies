"use client";

type Props = {
  data: any;
};

export const NftCard = ({ data }: Props) => {
  // let output;

  // if (data?.image) {
  //   output = (

  //   );
  // }

  return (
    <>
      <div className="w-[128px] lg:w-[350px] flex flex-col items-center justify-center bg-base-300 m-1 rounded-2xl border-2 border-yellow-300">
        {data?.image ? (
          <>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={data?.image} alt="Alt" className="w-[96px] h-[96px] lg:w-[128px] lg:h-[128px] m-2 rounded-lg" />
            <p className="font-bold text-center">{data?.name}</p>
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
