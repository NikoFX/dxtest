FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/runtime-deps:9.0 AS deps
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 

FROM base AS final
WORKDIR /app
COPY ./linux/ ./

COPY native/* /app/libs/

COPY native/* /app/


ENV LD_LIBRARY_PATH=/app:$LD_LIBRARY_PATH

ENTRYPOINT ["dotnet", "tap.Blazor.Server.dll"]
