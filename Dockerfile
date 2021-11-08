#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
#FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app
# Porta de entrada do container
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["WorkerService/WorkerService.csproj", "WorkerService/"]
RUN dotnet restore "WorkerService/WorkerService.csproj"
COPY . .
WORKDIR "/src/WorkerService"
RUN dotnet build "WorkerService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WorkerService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WorkerService.dll"]