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
      <div className="w-[256px] lg:w-[430px]  flex flex-col items-center justify-center m-1 rounded-2xl">
        {data?.image ? (
          <>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={data?.image} alt="Alt" className="m-2 rounded-lg" />
            <p className="font-bold text-center text-2xl lg:text-3xl">{data?.name}</p>
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
