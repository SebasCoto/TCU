# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar solo el csproj y restaurar para aprovechar cache
COPY ["TCUApi.csproj", "./"]
RUN dotnet restore "TCUApi.csproj"

# Copiar el resto del código
COPY . .

# Hacer build (esto genera obj y bin)
RUN dotnet build "TCUApi.csproj" -c Release -o /app/build

# Hacer publish (usar --no-build para no recompilar)
RUN dotnet publish "TCUApi.csproj" -c Release -o /app/publish --no-build /p:UseAppHost=false

# Etapa de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "TCUApi.dll"]
