#Server
$servidor= "\\Your server";

#List of printers on server.
$impresoras =  get-printer -ComputerName $servidor;

#Objets collection
$lista=@();
#Summatory
$contador=1;


#Printer class.

class Impresora {
    [string]$nombre; #Nombre de impresora.
    [int]$indice; #Indice con la que se instalará.
    #Constructor
    Impresora( 
        [String]$nombre,
        [String]$indice
    )
    {
        $this.nombre = $nombre
        $this.indice = $indice
                
    }
     
    #Installer method
    instalador($servidor){
        Remove-Printer *\$($this.nombre) -ErrorAction SilentlyContinue; #Delete printer if is installed yet.
        try{
            $fullname = Join-Path -Path \\$servidor\ -ChildPath $($this.nombre)
            Add-Printer -ConnectionName $fullname -ErrorAction Stop
            Write-Host "Instalada: "$($this.nombre) -backgroundcolor Green
        }
        catch #If error:
        {
            Write-Host "Can't setup $($this.nombre), please try again" -Foregroundcolor Red
        }
    
    }
}

#Prepare list
foreach($i in $impresoras.name){
    $lista+=[Impresora]::new($i,$contador);
    $contador+=1;

}

#Show list
function listar(){
    Write-Host ($lista | Format-Table | Out-String)
    [int]$instalar= Read-host -Prompt "Enter the number of the printer you want to install . To exit press enter 0"
    if($instalar -eq 0){
        exit;
    } elseif (($instalar -lt 1) -or ($instalar -gt $lista.length)){
        clear
        Write-Host "Introduce un número correcto" -backgroundcolor Red;
        listar;
    } else {
        $seleccion = $lista | Where-Object {$_.indice -eq $instalar}
        clear
        $seleccion.instalador($servidor)
        $seleccion=0;
        listar
    }    
}
clear
listar