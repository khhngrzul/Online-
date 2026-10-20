import Link from "next/link";

export default function Footer() {
  return (
    <footer className="flex justify-end items-center gap-6 px-8 py-4 text-xs text-gray-500">
      <Link href="#" className="hover:underline">Privacy</Link>
      <Link href="#" className="hover:underline">Community guidelines</Link>
      <span>© 2026</span>
    </footer>
  );
}