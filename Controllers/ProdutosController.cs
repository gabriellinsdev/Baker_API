using Baker_API.Domains;
using Baker_API.Interfaces;
using Baker_API.Services;
using Baker_API.Views;
using Microsoft.AspNetCore.Mvc;

namespace Baker_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProdutosController : ControllerBase
    {

        [HttpPut("Insert")]
        public IActionResult Insert(ProdutoView produto)
        {
            Produtos prod = new Produtos();
            RetornoView retorno = new RetornoView();

            try
            {
                prod.Insert(produto);

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

        [HttpPut("Update")]
        public IActionResult Update(ProdutoView produto)
        {
            Produtos prod = new Produtos();
            RetornoView retorno = new RetornoView();

            try
            {
                prod.Update(produto);

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

        [HttpPut("Delete")]
        public IActionResult Delete(int idProduto)
        {
            Produtos prod = new Produtos();
            RetornoView retorno = new RetornoView();

            try
            {
                prod.Delete(idProduto);

                retorno.Mensagem = "Registro excluído com sucesso!";
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
        public IActionResult List(Guid idUsuario)
        {
            Produtos prod = new Produtos();
            RetornoView retorno = new RetornoView();

            try
            {
                retorno.Data = prod.List(idUsuario);

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
