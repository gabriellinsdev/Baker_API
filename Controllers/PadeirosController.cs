using Baker_API.Domains;
using Baker_API.Services;
using Baker_API.Views;
using Microsoft.AspNetCore.Mvc;

namespace Baker_API.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class PadeirosController : Controller
    {
        [HttpGet("ListLocation")]
        public IActionResult ListLocation(string NM_CIDADE)
        {
            Padeiros padeiro = new Padeiros();
            RetornoView retorno = new RetornoView();

            try
            {
                retorno.Data = padeiro.ListarPadeiros(NM_CIDADE);

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

        [HttpGet("SalesReport")]
        public IActionResult SalesReport(Guid CD_USUARIO)
        {
            Padeiros padeiro = new Padeiros();
            RetornoView retorno = new RetornoView();

            try
            {
                retorno.Data = padeiro.RelatorioVendas(CD_USUARIO);

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
