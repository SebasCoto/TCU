//using Microsoft.OpenApi.Models;
//using Swashbuckle.AspNetCore.SwaggerGen;
//using System.Collections.Generic;

//namespace TCPUapi.Filters
//{
//    public class FileUploadOperation : IOperationFilter
//    {
//        public void Apply(OpenApiOperation operation, OperationFilterContext context)
//        {
//            // Solo aplicar el filtro para la acción "RegistrarArchivo"
//            if (operation.OperationId.ToLower().Contains("registrararchivo"))
//            {
//                operation.RequestBody = new OpenApiRequestBody
//                {
//                    Content = new Dictionary<string, OpenApiMediaType>
//                    {
//                        ["multipart/form-data"] = new OpenApiMediaType
//                        {
//                            Schema = new OpenApiSchema
//                            {
//                                Type = "object",
//                                Properties = new Dictionary<string, OpenApiSchema>
//                                {
//                                    ["archivo"] = new OpenApiSchema
//                                    {
//                                        Type = "string",
//                                        Format = "binary"
//                                    }
//                                }
//                            }
//                        }
//                    }
//                };
//            }
//        }



//    }
//}
