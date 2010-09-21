within Buildings.Fluid.Chillers.Data;
package ElectricReformulatedEIR
  "Performance data for chiller ElectricReformulatedEIR"

  record Generic "Generic data record for chiller ElectricReformulatedEIR"
    extends Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
    final nCapFunT=6,
    final nEIRFunT=6,
    final nEIRFunPLR=10);
    parameter Modelica.SIunits.Temperature TConLvg_nominal
      "Temperature of fluid leaving condenser at nominal condition";
    parameter Modelica.SIunits.Temperature TConLvgMin
      "Minimum value for leaving condenser temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Modelica.SIunits.Temperature TConLvgMax
      "Maximum value for leaving condenser temperature"
      annotation (Dialog(group="Performance curves"));

    annotation (Documentation(info="<html>
This record is used as a template for performance data 
for the chiller model
<a href=\"Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>.
</html>",   revisions="<html>
<ul>
<li>
September 17, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record ReformEIRChiller_McQuay_WSC_471kW_589COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal = -471200,
      COP_nominal =       5.89,
      PLRMin =            0.1,
      PLRMinUnl =         0.1,
      PLRMax =            1.08,
      mEva_flow_nominal = 0.01035*1000,
      mCon_flow_nominal = 0.01924*1000,
      TEvaLvg_nominal =   8.89 + 273.15,
      TConLvg_nominal =   33.52 + 273.15,
      TEvaLvgMin =        273.15+7.22,
      TEvaLvgMax =        273.15+12.78,
      TConLvgMin =        273.15+12.78,
      TConLvgMax =        273.15+35.09,
      capFunT =           {-4.862465E-01, -7.293218E-02, -8.514849E-03, 1.463106E-01, -4.474066E-03, 9.813408E-03},
      EIRFunT =           {3.522647E-01, -3.311790E-02, -1.374491E-04, 3.469525E-02, -3.624458E-04, 6.749423E-04},
      EIRFunPLR =         {8.215998E-01, -2.209969E-02, -1.725652E-05, -3.831448E-02, 1.896948E-01, 2.308518E-02, 0.000000E+00, 1.349969E-02, 0.000000E+00, 0.000000E+00},
      etaMotor =          1.0)
    "ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes"
    annotation (Documentation(info="<html>
Performance data for chiller model. 
This data corresponds to the following EnergyPlus model:
<pre>
! Manufacturer = McQuay, Model Line = WSC
! Reference Capacity = 471 kW (134 tons)
! Compressor Type = Centrifugal, Condenser Type = Water
! Refrigerant = N/A, Voltage & Phase = N/A
! Unloading Mechanism = Inlet Vanes
!
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes,  !- Name
    471200,                  !- Reference Capacity {W}
    5.89,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    33.52,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01035,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01924,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.08,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.10,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}

!
! Curve set (3 Curves):
!
! Cooling Capacity Function of Temperature Curve
! x = Leaving Chilled Water Temperature and y = Leaving Condenser Water Temperature
Curve:Biquadratic,
    ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes CAPFT,  !- Name
    -4.862465E-01,           !- Coefficient1 Constant
    -7.293218E-02,           !- Coefficient2 x
    -8.514849E-03,           !- Coefficient3 x**2
    1.463106E-01,            !- Coefficient4 y
    -4.474066E-03,           !- Coefficient5 y**2
    9.813408E-03,            !- Coefficient6 x*y
    7.22,                    !- Minimum Value of x
    12.78,                   !- Maximum Value of x
    18.81,                   !- Minimum Value of y
    35.09;                   !- Maximum Value of y

!
! Energy Input to Cooling Output Ratio Function of Temperature Curve
! x = Leaving Chilled Water Temperature and y = Leaving Condenser Water Temperature
Curve:Biquadratic,
    ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes EIRFT,  !- Name
    3.522647E-01,            !- Coefficient1 Constant
    -3.311790E-02,           !- Coefficient2 x
    -1.374491E-04,           !- Coefficient3 x**2
    3.469525E-02,            !- Coefficient4 y
    -3.624458E-04,           !- Coefficient5 y**2
    6.749423E-04,            !- Coefficient6 x*y
    7.22,                    !- Minimum Value of x
    12.78,                   !- Maximum Value of x
    18.81,                   !- Minimum Value of y
    35.09;                   !- Maximum Value of y

!
! Energy Input to Cooling Output Ratio Function of Part Load Ratio Curve
! x = Leaving Condenser Water Temperature and y = Part Load Ratio (load/capacity)
Curve:Bicubic,
    ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes EIRFPLR,  !- Name
    8.215998E-01,            !- Coefficient1 Constant
    -2.209969E-02,           !- Coefficient2 x
    -1.725652E-05,           !- Coefficient3 x**2
    -3.831448E-02,           !- Coefficient4 y
    1.896948E-01,            !- Coefficient5 y**2
    2.308518E-02,            !- Coefficient6 x*y
    0.000000E+00,            !- Coefficient7 x**3
    1.349969E-02,            !- Coefficient8 y**3
    0.000000E+00,            !- Coefficient9 x**2*y
    0.000000E+00,            !- Coefficient10 x*y**2
    17.52,                   !- Minimum Value of x
    33.32,                   !- Maximum Value of x
    0.10,                    !- Minimum Value of y
    1.08;                    !- Maximum Value of y
</pre>
</html>"));

  annotation(preferedView="info",
  Documentation(info="<html>
This package contains performance data 
for the chiller model
<a href=\"Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>.
</html>", revisions="<html>
<ul>
<li>
September 17, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ElectricReformulatedEIR;
