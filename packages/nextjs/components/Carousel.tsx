import { useEffect, useState } from "react";
import carouselImage2 from "../public/images-carousel/2.png";
import carouselImage3 from "../public/images-carousel/3.png";
import carouselImage4 from "../public/images-carousel/4.png";
import carouselImage5 from "../public/images-carousel/5.png";
import Card from "./Card";
import { config } from "react-spring";
import Carousel from "react-spring-3d-carousel";

const staticCards = [
  {
    key: 1,
    content: (
      <Card
        imagen="https://updates.theme-fusion.com/wp-content/uploads/2017/12/convertplus_thumbnail.jpg"
        image={carouselImage2.src}
      />
    ),
  },
  {
    key: 2,
    content: (
      <Card
        imagen="https://updates.theme-fusion.com/wp-content/uploads/2017/12/acf_pro.png"
        image={carouselImage2.src}
      />
    ),
  },
  {
    key: 3,
    content: (
      <Card
        imagen="https://updates.theme-fusion.com/wp-content/uploads/2017/12/layer_slider_plugin_thumb.png"
        image={carouselImage3.src}
      />
    ),
  },
  {
    key: 4,
    content: (
      <Card
        imagen="https://updates.theme-fusion.com/wp-content/uploads/2016/08/slider_revolution-1.png"
        image={carouselImage4.src}
      />
    ),
  },
  {
    key: 5,
    content: (
      <Card
        imagen="https://updates.theme-fusion.com/wp-content/uploads/2016/08/slider_revolution-1.png"
        image={carouselImage5.src}
      />
    ),
  },
];

export default function Carroussel() {
  const offset = 2;

  const table = staticCards.map((element: any, index: any) => {
    return { ...element, onClick: () => setGoToSlide(index) };
  });

  const [offsetRadius, setOffsetRadius] = useState(2);
  const [showArrows, setShowArrows] = useState(false);
  const [goToSlide, setGoToSlide] = useState<any>(null);
  const [cards] = useState(table);

  useEffect(() => {
    setOffsetRadius(offset);
    setShowArrows(showArrows);
  }, [offset, showArrows]);

  return (
    <div className="w-[330px] lg:w-[600px] h-[200px] m-auto">
      <Carousel
        slides={cards}
        goToSlide={goToSlide}
        offsetRadius={offsetRadius}
        showNavigation={showArrows}
        animationConfig={config.gentle}
      />
    </div>
  );
}
