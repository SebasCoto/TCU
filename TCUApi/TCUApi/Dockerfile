# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Restaurar dependencias
COPY TCUApi.csproj ./
RUN dotnet restore "TCUApi.csproj"

# Copiar el resto del proyecto
COPY . ./

# Publicar en carpeta de salida
RUN dotnet publish "TCUApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "TCUApi.dll"]
