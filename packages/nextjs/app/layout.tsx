import "@rainbow-me/rainbowkit/styles.css";
import { Metadata } from "next";
import { ScaffoldEthAppWithProviders } from "~~/components/ScaffoldEthAppWithProviders";
import { ThemeProvider } from "~~/components/ThemeProvider";
import "~~/styles/globals.css";

const baseUrl = "https://weedies-nextjs.vercel.app/";
// ? `https://${process.env.VERCEL_URL}`
// : `http://localhost:${process.env.PORT || 3000}`;
const imageUrl = `${baseUrl}/hero.png`;

export const metadata: Metadata = {
  metadataBase: new URL(baseUrl),
  title: {
    default: "Weedies",
    template: "%s | Weedies",
  },
  description: "Somebody pass the joint!",
  openGraph: {
    title: {
      default: "Weedies",
      template: "%s | Weedies",
    },
    description: "Somebody pass the joint!",
    images: [
      {
        url: imageUrl,
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    images: [imageUrl],
    title: {
      default: "Weedies",
      template: "%s | Weedies",
    },
    description: "Somebody pass the joint!",
  },
  icons: {
    icon: [{ url: "/weedies-favicon.png", sizes: "32x32", type: "image/png" }],
  },
};

const ScaffoldEthApp = ({ children }: { children: React.ReactNode }) => {
  return (
    <html suppressHydrationWarning>
      <body>
        <ThemeProvider enableSystem>
          <ScaffoldEthAppWithProviders>{children}</ScaffoldEthAppWithProviders>
        </ThemeProvider>
      </body>
    </html>
  );
};

export default ScaffoldEthApp;
