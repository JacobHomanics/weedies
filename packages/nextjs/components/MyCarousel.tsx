import React from "react";
import nounie1 from "../public/carousel/1.png";
import nounie2 from "../public/carousel/2.png";
import nounie3 from "../public/carousel/3.png";
import nounie4 from "../public/carousel/4.png";
import Carousel from "react-multi-carousel";

/**
 * Site footer
 */
export const MyCarousel = () => {
  const carouselImgClassName = "border-2 border-secondary rounded-2xl";
  const imgContainerClassName = "m-2";

  return (
    <Carousel
      additionalTransfrom={0}
      arrows
      autoPlay
      autoPlaySpeed={1000}
      centerMode
      className="w-[280px] lg:w-[480px] "
      containerClass="container"
      dotListClass="rounded-lg"
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
      <div className={imgContainerClassName}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={nounie1.src} alt="Fruits" className={carouselImgClassName} />
      </div>

      <div className={imgContainerClassName}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={nounie2.src} alt="Fruits" className={carouselImgClassName} />
      </div>

      <div className={imgContainerClassName}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={nounie3.src} alt="Fruits" className={carouselImgClassName} />
      </div>

      <div className={imgContainerClassName}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={nounie4.src} alt="Fruits" className={carouselImgClassName} />
      </div>
    </Carousel>
  );
};
