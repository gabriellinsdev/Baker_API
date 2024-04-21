using Baker_API.Services;
using Baker_API.Views;
using Microsoft.AspNetCore.Mvc;

namespace Baker_API.Controllers
{
    public class CarrinhoController : Controller
    {

        [HttpPut("Save")]
        public IActionResult Save([FromBody] List<CarrinhoView> carrinhoItens)
        {
            Carrinho carr = new Carrinho();
            RetornoView retorno = new RetornoView();

            try
            {
                if (carrinhoItens == null || carrinhoItens.Count() == 0)
                {
                    retorno.Mensagem = "Nenhum item foi incluído no Carrinho!";
                    return BadRequest(retorno);
                }

                carr.Save(carrinhoItens);

                retorno.Mensagem = "Itens do Carrinho salvo com sucesso!";

                return Ok(retorno);
            }
            catch (Exception ex)
            {
                retorno.Mensagem = "Erro de Sistema";
                retorno.StackTrace = ex.Message + "/n" + ex.StackTrace;
                return BadRequest(retorno);
            }
        }

        [HttpGet("List")]
        public IActionResult List(Guid CD_USUARIO)
        {
            Carrinho carr = new Carrinho();
            RetornoView retorno = new RetornoView();

            try
            {
                retorno.Data = carr.List(CD_USUARIO);

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
