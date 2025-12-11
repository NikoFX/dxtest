# Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY DXApplication1/ ./DXApplication1/

RUN dotnet publish DXApplication1/DXApplication1.Blazor.Server/DXApplication1.Blazor.Server.csproj \
     -c Release \
    -o /app/publish \
    -r linux-x64 \
    --self-contained false \
    /p:UseAppHost=false

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY DXApplication1/DXApplication1.Blazor.Server/DXApplication1.sqlite /app/DXApplication1.sqlite

RUN apt-get update && \
    apt-get install -y \
    libfontconfig1 \
    libfreetype6 \
    libpng16-16 \
    libjpeg62-turbo \
    libxcb1 \
    libx11-6 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*


COPY --from=build /app/publish .

# Render persistent volume:
ENV DATA_DIR=/var/data

# Create folder like Render expects
RUN mkdir -p /var/data

COPY DXApplication1/DXApplication1.Blazor.Server/DXApplication1.sqlite /app/DXApplication1.sqlite
# SkiaSharp native libs
#COPY --from=build /root/.nuget/packages/*/*/runtimes/linux-x64/native/* /app/libs/

COPY native/* /app/

ENV LD_LIBRARY_PATH=/app:$LD_LIBRARY_PATH


ENTRYPOINT ["dotnet", "DXApplication1.Blazor.Server.dll"]
