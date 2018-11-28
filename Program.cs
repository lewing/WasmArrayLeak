using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using WebAssembly;

namespace WasmArrayLeak
{
    public class Program
    {
        static string BaseApiUrl = string.Empty;
        static HttpClient httpClient;

        static void Main(string[] argss)
        {

            BaseApiUrl = "http://localhost";
            httpClient = new HttpClient() { BaseAddress = new Uri(BaseApiUrl) };

        }

        private static void PassByteBuffer(byte[] buffer)
        {

            Console.WriteLine($"Buffer length: {buffer?.Length}");

        }


        private static void AllocByteBuffer(int size)
        {
            var buffer = new byte[size];
        }

    }
}
