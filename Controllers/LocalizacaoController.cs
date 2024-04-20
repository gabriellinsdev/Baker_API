using Baker_API.Services;
using Baker_API.Views;
using Microsoft.AspNetCore.Mvc;
using System.Net;

namespace Baker_API.Controllers
{
    public class LocalizacaoController : Controller
    {

        [HttpGet("Location")]
        public IActionResult Location(string CD_CEP)
        {
            GoogleMaps maps = new GoogleMaps();
            RetornoView retorno = new RetornoView();

            try
            {
                // Pesquisa Latitude/Longitudo do Cliente pelo CEP
                LocalizacaoView localizacao = GoogleMaps.ZipCodeSearch(CD_CEP);


                // Lista de padeiros por Cidade
                Padeiros padeiro = new  Padeiros();
                List<PadeiroView> lstPadeiros  = padeiro.ListarPadeiros(localizacao.NM_CIDADE);


                // Retornar a localização de cada padeiro próximo do cliente
                padeiro.ListarLocalizacaoPadeiro(localizacao, lstPadeiros);


                // Retornar os 3 padeiros mais próximos da localização do cliente
                retorno.Data = padeiro.ListarMelhorLocalizacao(localizacao, lstPadeiros);

                if (retorno.Data == null)
                {
                    retorno.Mensagem = "Nenhum registro encontrado!";
                }

                return Ok(retorno);
            }
            catch (Exception ex)
            {
                retorno.Mensagem = "Erro de Sistema";
                retorno.StackTrace = ex.Message + "/n" + ex.StackTrace;
                return BadRequest(retorno);
            }
        }
    }
}
