import Image from "next/image";

export default function Header() {
  return (
    <header className="flex justify-between items-center px-8 py-6">
      <div className="flex items-center gap-3">
        <Image 
          src="/unnamed.png" 
          alt="School Logo" 
          width={50} 
          height={50} 
          className="object-contain"
        />
        <h1 className="font-bold text-lg md:text-xl text-[#1a2e40]">
          Мандах Мэдээллийн Технологийн их сургууль
        </h1>
      </div>
    </header>
  );
}