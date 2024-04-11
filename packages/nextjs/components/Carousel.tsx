import carouselImage2 from "../public/images-carousel/2.png";
import carouselImage3 from "../public/images-carousel/3.png";
import carouselImage4 from "../public/images-carousel/4.png";
import carouselImage5 from "../public/images-carousel/5.png";
import carouselImage6 from "../public/images-carousel/6.png";
import Slider from "react-slick";
import "slick-carousel/slick/slick-theme.css";
// import "slick-carousel/slick/slick-theme.css";
// import Carousel from "react-spring-3d-carousel";
// import Carousel
// import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick.css";

export default function Carroussel() {
  const settings = {
    dots: true,
    infinite: true,
    speed: 500,
    slidesToShow: 3,
    slidesToScroll: 1,
    centerMode: true,
    centerPadding: "10px",
    autoplay: true,
    autoplaySpeed: 2000,
  };

  return (
    <div className="w-[380px] lg:w-[800px] slider-container">
      <Slider {...settings} className="">
        <img src={carouselImage2.src} className="p-1 lg:p-5" />
        <img src={carouselImage3.src} className="p-1 lg:p-5" />
        <img src={carouselImage4.src} className="p-1 lg:p-5" />
        <img src={carouselImage5.src} className="p-1 lg:p-5" />
        <img src={carouselImage6.src} className="p-1 lg:p-5" />
      </Slider>
    </div>
  );
}
