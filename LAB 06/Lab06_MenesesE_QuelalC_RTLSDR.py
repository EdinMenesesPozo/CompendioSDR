import SoapySDR
results = SoapySDR.Device.enumerate()
for result in results:
    print(result)

# Crear instancia del dispositivo LimeSDR
args = dict(driver="lime", serial="00090726074F2503")  # Ajusta el serial según tu dispositivo
sdr = SoapySDR.Device(args)

# Imprimir tipos de antenas compatibles
antennas = sdr.listAntennas(SoapySDR.SOAPY_SDR_RX, 0)
print("Tipos de antenas disponibles:", antennas)