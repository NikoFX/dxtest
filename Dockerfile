# Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY DXApplication1/ ./DXApplication1/

RUN dotnet publish DXApplication1/DXApplication1.Blazor.Server/DXApplication1.Blazor.Server.csproj \
    -c Release \
    -o /app/publish \
    --self-contained false \
    /p:UseAppHost=false

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY DXApplication1/DXApplication1.Blazor.Server/DXApplication1.sqlite /app/DXApplication1.sqlite

COPY --from=build /app/publish .

# Render persistent volume:
ENV DATA_DIR=/var/data

# Create folder like Render expects
RUN mkdir -p /var/data

COPY DXApplication1/DXApplication1.Blazor.Server/DXApplication1.sqlite /app/DXApplication1.sqlite

ENTRYPOINT ["dotnet", "DXApplication1.Blazor.Server.dll"]
