import React, { useState } from "react";
import Styles from "./Card.module.css";
import { animated, useSpring } from "react-spring";

type Props = {
  imagen: string;
  image: string;
};
function Card({ image }: Props) {
  const [show, setShown] = useState(false);

  const props3 = useSpring({
    transform: show ? "scale(1.03)" : "scale(1)",
    boxShadow: show ? "0 20px 25px rgb(0 0 0 / 25%)" : "0 2px 10px rgb(0 0 0 / 8%)",
  });

  // display: flex;
  // flex-direction: column;
  // justify-content: center;
  // width: 12rem;
  // height: fit-content;
  // border-radius: 10px;

  return (
    <animated.div
      className={Styles.card}
      // className={Styles.card}
      style={props3}
      onMouseEnter={() => setShown(true)}
      onMouseLeave={() => setShown(false)}
    >
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img src={image} alt="Test" />
      {/* <h2>Title</h2>
      <p>
        Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet
        dolore magna aliquam erat volutpat.
      </p>
      <div className={Styles.btnn}>
        <Button text="Demo" />
        <Button text="Code" />
      </div> */}
    </animated.div>
  );
}

export default Card;
