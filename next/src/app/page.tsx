"use client";

import { useState } from "react";
import Link from "next/link";
import { Mail, Lock, Eye, EyeOff, GraduationCap, ArrowRight, Puzzle } from "lucide-react";
import Header from "./components/Header";
import Footer from "./components/Footer";
import Image from "next/image";

export default function Home() {
  const [showPassword, setShowPassword] = useState(false);
  const [formData, setFormData] = useState({
    email: "",
    password: "",
    rememberMe: false,
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log("Оруулсан дата:", formData);
    alert(`Имэйл: ${formData.email}\nНууц үг: ${formData.password}`);
  };

  return (
    <div className="min-h-screen bg-[#e3f6f5] flex flex-col justify-between text-[#1e293b]">
      
     
      <Header />

     
      <main className="flex-1 flex items-center justify-center px-4 py-6">
        <div className="w-full max-w-6xl grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          
         
          <div className="flex flex-col space-y-6">
            <div>
              <h2 className="text-4xl md:text-5xl font-extrabold text-[#1a2a3a] mb-4">
                Уриа бичнэ...
              </h2>
              <p className="text-gray-600 text-sm md:text-base leading-relaxed">
                Хайснаа ол, хэрэггүйгээ зар.<br />
                Танилц, хуваалц, хүрээллээ тэл.
              </p>
            </div>

            
          
            <div className="bg-[#1b3d82] rounded-2xl relative overflow-hidden shadow-inner w-full"> 
              <Image 
                src="/puzzle.jpg" 
                alt="Banner" 
                width={800} 
                height={400}
                className="w-full h-auto object-contain" 
              />
            </div>

           
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
              <div className="bg-[#8ee4d7] p-5 rounded-2xl shadow-sm transform -rotate-1 hover:rotate-0 transition-transform">
                <span className="text-[10px] font-semibold tracking-wider uppercase bg-white/40 px-2 py-0.5 rounded text-gray-700">
                   энд бас
                </span>
                <h3 className="font-bold text-lg text-[#0f172a] mt-2">
                  Шинэ мэдээлэл?
                </h3>
                <p className="text-xs text-gray-600 mt-1">мэдээлэл</p>
              </div>

              <div className="bg-[#1b1c4e] p-5 rounded-2xl shadow-md text-white transform rotate-1 hover:rotate-0 transition-transform">
                <span className="text-[10px] font-semibold tracking-wider uppercase bg-white/10 px-2 py-0.5 rounded text-gray-300">
                  ⇆ энд нэг зүйл бичнэ дээ
                </span>
                <h3 className="font-bold text-base mt-2 leading-snug">
                  Таны хуучин зүйл<br />Бусдын шинэ эхлэл.
                </h3>
                <p className="text-xs text-gray-400 mt-2">энд бас</p>
              </div>
            </div>
          </div>

          
          <div className="flex flex-col justify-center max-w-md mx-auto w-full">
            <h2 className="text-3xl font-bold text-[#1b1c4e] tracking-tight">
              welcome to market
            </h2>
            <p className="text-sm text-gray-500 mt-1 mb-8">
              Өнөөдрийн шинэ зүйл юу байна?
            </p>

            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                  School email
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Mail size={18} />
                  </div>
                  <input
                    type="email"
                    required
                    placeholder="you@school.edu"
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    className="w-full pl-10 pr-4 py-3 bg-white/60 border border-emerald-100 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1b1c4e]/20 focus:bg-white text-sm transition-all"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-700 mb-1.5">
                  Password
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                    <Lock size={18} />
                  </div>
                  <input
                    type={showPassword ? "text" : "password"}
                    required
                    placeholder="Enter your password"
                    value={formData.password}
                    onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                    className="w-full pl-10 pr-10 py-3 bg-white/60 border border-emerald-100 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1b1c4e]/20 focus:bg-white text-sm transition-all"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-gray-600"
                  >
                    {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </div>

              <div className="flex items-center justify-between text-xs">
                <label className="flex items-center space-x-2 cursor-pointer text-gray-600">
                  <input
                    type="checkbox"
                    checked={formData.rememberMe}
                    onChange={(e) => setFormData({ ...formData, rememberMe: e.target.checked })}
                    className="w-4 h-4 rounded border-gray-300 text-[#1b1c4e] focus:ring-[#1b1c4e]"
                  />
                  <span>Remember me</span>
                </label>
                <Link href="#" className="font-semibold text-gray-700 hover:underline">
                  Forgot password?
                </Link>
              </div>

              <button
                type="submit"
                className="w-full bg-[#1b1c4e] hover:bg-[#121338] text-white py-3.5 rounded-xl font-medium text-sm flex items-center justify-center space-x-2 transition-colors shadow-sm"
              >
                <span>Sign in</span>
                <ArrowRight size={16} />
              </button>
            </form>

            <div className="relative my-6 text-center">
              <span className="text-[11px] text-gray-400 bg-[#e3f6f5] px-3">
                or use your school account
              </span>
            </div>

            <button
              type="button"
              className="w-full bg-white/60 border border-emerald-100 hover:bg-white text-gray-700 py-3 rounded-xl font-medium text-sm flex items-center justify-center space-x-2 transition-all shadow-sm"
            >
              <GraduationCap size={18} />
              <span>Continue with school</span>
            </button>

            <div className="text-center mt-6 text-xs text-gray-600">
              Шинэ хэрэглэгч үү?{" "}
              <Link href="#" className="font-bold text-[#1b1c4e] hover:underline ml-1">
                Аккаунт үүсгэх үү?
              </Link>
            </div>
          </div>

        </div>
      </main>

      
      <Footer />

    </div>
  );
}