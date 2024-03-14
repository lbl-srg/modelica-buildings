within Buildings.Fluid.Storage.PCM.Data.HeatExchanger;
record Generic
  "Record for phase change material heat exchanger design"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Energy TesDesign = 10*3600000 "Design Capacity (factor * 1kWh to J)" annotation(Dialog(group="Sizing"));

  parameter Modelica.Units.SI.Length D = 0.5 "Depth of finned tube heat exchanger"
                                                                                  annotation(Dialog(group="Heat Exchanger"));
  parameter Modelica.Units.SI.Length W = 0.5 "Width of finned tube heat exchanger"
                                                                                  annotation(Dialog(group="Heat Exchanger"));
  parameter Real coeff_H = 0.5 "Height of finned tube heat exchanger"
                                                                     annotation(Dialog(group="Heat Exchanger"));

  parameter Integer Ntubebanks = 6 "Number of tube banks in heat exchanger"
                                                                           annotation(Dialog(group="Tubes"));
  parameter Integer Ntubes_bank = 6 "Number of tubes per bank in heat exchanger"
                                                                                annotation(Dialog(group="Tubes"));

  parameter Modelica.Units.SI.Length do = 0.0045 "Outer diameter of tube in heat exchanger"
                                                                                           annotation(Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length di = 0.0040 "Inner diameter of tube in heat exchanger"
                                                                                           annotation(Dialog(group="Tubes"));

  parameter Modelica.Units.SI.MacroscopicCrossSection Nfins_meter = 500 "Number of fins per meter"
                                                                                                  annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length t_fin = 0.0001 "Thickness of each fin"
                                                                           annotation(Dialog(group="Fins"));

  // parameter Modelica.Units.SI.DynamicViscosity muw = 8.9e-4 "Dynamic viscosity of working fluid at 25 C" annotation(Dialog(group="Convection Correlation"));
  // parameter Modelica.Units.SI.SpecificHeatCapacity cpw = 4138  "Specific heat capacity of working fluid at 25 C" annotation(Dialog(group="Convection Correlation"));
  // parameter Modelica.Units.SI.ThermalConductivity kw = 0.607 "Thermal conductivity of working fluid at 25 C" annotation(Dialog(group="Convection Correlation"));
  // parameter Modelica.Units.SI.DimensionlessRatio Prw = (muw*cpw)/kw "Prandtl number of working fluid" annotation(Dialog(group="Convection Correlation"));


end Generic;
