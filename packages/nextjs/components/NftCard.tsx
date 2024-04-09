"use client";

type Props = {
  data: any;
};

export const NftCard = ({ data }: Props) => {
  return (
    <div className="w-[128px] lg:w-[350px] flex flex-col items-center justify-center bg-base-300 m-1 rounded-2xl border-2 border-yellow-300">
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img src={data?.image} alt="Alt" className="w-[96px] h-[96px] lg:w-[128px] lg:h-[128px] m-2 rounded-lg" />
      <p className="font-bold text-center">{data?.name}</p>
    </div>
  );
};
