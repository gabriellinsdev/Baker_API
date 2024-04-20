using Baker_API.Interfaces;
using Baker_API.Models;
using Baker_API.Views;

namespace Baker_API.Services
{
    public class Padeiros : IPadeiros
    {
        public List<PadeiroView> List(string NM_CIDADE)
        {
            try
            {
                Repository.PadeiroRepository rep = new Repository.PadeiroRepository();

                List<PadeiroModel> lista = rep.List(NM_CIDADE);
                List<PadeiroView> Padeiros = new List<PadeiroView>();

                foreach (PadeiroModel PadeiroModel in lista)
                {
                    PadeiroView model = new PadeiroView();
                    model = Converter(PadeiroModel);

                    Padeiros.Add(model);
                }

                return Padeiros;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static async Task GoogleMaps(string endereco)
        {
            // Chave de API do Google Maps
            string apiKey = "SuaChaveDeAPI";

            // URL da requisição à API de Geocodificação
            string apiUrl = $"https://maps.googleapis.com/maps/api/geocode/json?address={endereco}&key={apiKey}";

            using (HttpClient client = new HttpClient())
            {
                // Realiza a requisição à API do Google Maps
                HttpResponseMessage response = await client.GetAsync(apiUrl);

                // Verifica se a requisição foi bem-sucedida
                if (response.IsSuccessStatusCode)
                {
                    // Lê a resposta como uma string
                    string jsonResult = await response.Content.ReadAsStringAsync();

                    // Aqui você pode analisar o JSON retornado para obter os dados de localização
                    Console.WriteLine(jsonResult);
                }
                else
                {
                    Console.WriteLine($"Erro ao acessar a API do Google Maps: {response.StatusCode}");
                }
            }
        }

        private PadeiroModel Converter(PadeiroView Padeiro)
        {
            PadeiroModel obj = new PadeiroModel();

            obj.CD_USUARIO = Padeiro.CD_USUARIO;
            obj.NM_USUARIO = Padeiro.NM_USUARIO;
            obj.DS_EMAIL = Padeiro.DS_EMAIL;
            obj.DS_TELEFONE = Padeiro.DS_TELEFONE;
            obj.NM_ESTADO = Padeiro.NM_ESTADO;
            obj.NM_CIDADE = Padeiro.NM_CIDADE;
            obj.DS_ENDERECO = Padeiro.DS_ENDERECO;
            obj.CD_CEP = Padeiro.CD_CEP;
            obj.CD_SENHA = Padeiro.CD_SENHA;
            obj.CD_CPF_CNPJ = Padeiro.CD_CPF_CNPJ;

            return obj;
        }

        private PadeiroView Converter(PadeiroModel Padeiro)
        {
            PadeiroView obj = new PadeiroView();

            obj.CD_USUARIO = Padeiro.CD_USUARIO;
            obj.NM_USUARIO = Padeiro.NM_USUARIO;
            obj.DS_EMAIL = Padeiro.DS_EMAIL;
            obj.DS_TELEFONE = Padeiro.DS_TELEFONE;
            obj.NM_ESTADO = Padeiro.NM_ESTADO;
            obj.NM_CIDADE = Padeiro.NM_CIDADE;
            obj.DS_ENDERECO = Padeiro.DS_ENDERECO;
            obj.CD_CEP = Padeiro.CD_CEP;
            obj.CD_SENHA = Padeiro.CD_SENHA;
            obj.CD_CPF_CNPJ = Padeiro.CD_CPF_CNPJ;

            return obj;
        }
    }
}
