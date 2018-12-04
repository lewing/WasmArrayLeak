using System;
using System.Collections.Generic;
using System.Net.Http;
using WebAssembly.Net.Http.HttpClient; 
using System.Threading.Tasks;
using WebAssembly;
using System.Threading;

namespace WasmArrayLeak
{
    public class Program
    {
        static string BaseApiUrl = string.Empty;
        static HttpClient httpClient;

        static void Main(string[] argss)
        {


        }

        private static void PassByteBuffer(byte[] buffer)
        {

            Console.WriteLine($"Buffer length: {buffer?.Length}");

        }


        private static void AllocByteBuffer(int size)
        {
            var buffer = new byte[size];
        }

        static int requests = 0;
        static CancellationTokenSource cts = null;

        private static async void HttpClientRequest(string url)
        {
            checkHttpClient();

            //string ApiFile = "SampleJPGImage_30mbmb.jpg";
            Console.WriteLine($"url: {url}");
            Console.WriteLine($"streaming supported: { WasmHttpMessageHandler.StreamingSupported}");
            //WasmHttpMessageHandler.StreamingEnabled = false;
            Console.WriteLine($"streaming enabled: {WasmHttpMessageHandler.StreamingEnabled}");
            cts = new CancellationTokenSource();

            try
            {
                using (var rspMsg = await httpClient.GetAsync(url, cts.Token))
                {
                    Console.WriteLine(rspMsg.Content.Headers.ContentLength);
                    using (var respStream = rspMsg.Content?.ReadAsStreamAsync().Result)
                    {
                        Console.WriteLine($"Request: {++requests}  StreamAsync: {respStream.Length} Code: {rspMsg.StatusCode}");
                    }
                }
            }
            catch (Exception exc2)
            {
                Console.WriteLine($"HttpClientRequest: {exc2.Message} StackTrace: {exc2.StackTrace}");
                Console.WriteLine($"HttpClientRequest inner: {exc2.InnerException?.Message}");
                Console.WriteLine($"HttpClientRequest token cancallation requested: {cts.IsCancellationRequested}");
            }

        }

        static void checkHttpClient ()
        {
            if (httpClient == null)
            {
                Console.WriteLine("Create  HttpClient");
                var window = (JSObject)WebAssembly.Runtime.GetGlobalObject("window");
                using (var location = (JSObject)window.GetObjectProperty("location"))
                {
                    BaseApiUrl = (string)location.GetObjectProperty("origin");
                }

                httpClient = new HttpClient() { BaseAddress = new Uri(BaseApiUrl) };
            }

        }
    }
}
