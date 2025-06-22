# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiamos sólo el proyecto y restauramos dependencias (sin obj ni bin)
COPY ["TCUApi.csproj", "./"]
RUN dotnet restore "TCUApi.csproj"

# Copiamos sólo el código fuente (excluyendo bin y obj por .dockerignore)
COPY . .

RUN dotnet publish "TCUApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080

ENTRYPOINT ["dotnet", "TCUApi.dll"]
