import SoapySDR
import numpy as np
import matplotlib.pyplot as plt
from scipy.io.wavfile import write

# Crear instancia del dispositivo LimeSDR
args = dict(driver="lime", serial="00090726074F2503")  # Ajusta el serial según tu dispositivo
sdr = SoapySDR.Device(args)

# Configuración de LimeSDR
sample_rate = 1e6  # Frecuencia de muestreo en Hz
center_frequency = e3 # Frecuencia central en Hz
gain = 2  # Ganancia en dB
antenna = "NONE"  # Tipo de antena (ajusta según tu configuración)
calibrate = True  # Opción de calibración

# Configurar el dispositivo LimeSDR
sdr.setSampleRate(SoapySDR.SOAPY_SDR_RX, 0, sample_rate)
sdr.setFrequency(SoapySDR.SOAPY_SDR_RX, 0, center_frequency)
sdr.setGain(SoapySDR.SOAPY_SDR_RX, 0, gain)
sdr.setAntenna(SoapySDR.SOAPY_SDR_RX, 0, antenna)

if calibrate:
    sdr.setDCOffsetMode(SoapySDR.SOAPY_SDR_RX, 0, True)
else:
    sdr.setDCOffsetMode(SoapySDR.SOAPY_SDR_RX, 0, False)

# Configuración del flujo
rxStream = sdr.setupStream(SoapySDR.SOAPY_SDR_RX, SoapySDR.SOAPY_SDR_CF32)
sdr.activateStream(rxStream)

# Crear un búfer para las muestras
buff = np.zeros(1024, dtype=np.complex64)

# Archivo WAV de salida
output_wav_file = 'captura_lime.wav'
sample_rate = int(sdr.getSampleRate(SoapySDR.SOAPY_SDR_RX, 0))

# Configuración del gráfico
plt.ion()
fig, ax = plt.subplots()
line, = ax.plot([], label='Spectrum')
ax.set_title('LimeSDR Spectrum Visualization')
ax.set_xlabel('Frequency (Hz)')
ax.set_ylabel('Amplitude')
ax.legend()

# Recibir y graficar espectro de frecuencia en tiempo real
for i in range(10):
    sr = sdr.readStream(rxStream, [buff], len(buff))
    samples = buff[:sr.ret]
    spectrum = np.fft.fft(samples)
    freqs = np.fft.fftfreq(len(samples), d=1/sdr.getSampleRate(SoapySDR.SOAPY_SDR_RX, 0))

    ax.clear()
    line, = ax.plot(freqs, np.abs(spectrum), label='Spectrum')
    ax.set_title('LimeSDR Spectrum Visualization')
    ax.set_xlabel('Frequency (Hz)')
    ax.set_ylabel('Amplitude')
    ax.legend()
    plt.pause(0.1)

    # Guardar los datos en un archivo WAV (dos canales)
    write(output_wav_file, sample_rate, np.column_stack((np.real(samples), np.imag(samples))))

# Cerrar el flujo y finalizar
sdr.deactivateStream(rxStream)
sdr.closeStream(rxStream)
sdr = None  # Liberar la instancia del dispositivo LimeSDR
plt.ioff()
plt.show()
