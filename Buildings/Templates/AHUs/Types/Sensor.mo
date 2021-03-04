within Buildings.Templates.AHUs.Types;
type Sensor = enumeration(
    DifferentialPressure
    "Differential pressure",
    HumidityRatio
    "Humidity ratio",
    None
    "None",
    PPM
    "PPM",
    RelativeHumidity
    "Relative humidity",
    Temperature
    "Temperature",
    VolumeFlowRate
    "Volume flow rate")
  "Enumeration to configure the sensor";
