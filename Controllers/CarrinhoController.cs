using Baker_API.Services;
using Baker_API.Views;
using Microsoft.AspNetCore.Mvc;

namespace Baker_API.Controllers
{
    public class CarrinhoController : Controller
    {

        [HttpPut("Save")]
        public IActionResult Save(List<CarrinhoView> carrinho)
        {
            Carrinho carr = new Carrinho();
            RetornoView retorno = new RetornoView();

            try
            {
                carr.Save(carrinho);

                retorno.Mensagem = "Salvo com sucesso!";
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
