#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/dotnet:2.2-aspnetcore-runtime as base
WORKDIR /app


FROM microsoft/dotnet:2.2-sdk as build

COPY ["Person.api.csproj", "./"]
RUN dotnet restore "./Person.api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Person.api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Person.api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Person.api.dll"]
