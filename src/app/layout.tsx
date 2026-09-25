import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'RentMyCar',
  description: 'Alquiler de vehículos entre personas',
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="pt-BR"><body>{children}</body></html>;
}
