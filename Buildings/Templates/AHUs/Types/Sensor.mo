within Buildings.Templates.AHUs.Types;
type Sensor = enumeration(
    AbsoluteHumidity
    "Absolute humidity",
    DifferentialPressure
    "Differential pressure",
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
