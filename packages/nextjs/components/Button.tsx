import Styles from "./Button.module.css";

type Props = {
  text: string;
};

export const Button = ({ text }: Props) => {
  return <button className={Styles.btn}>{text}</button>;
};
