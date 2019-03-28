within Buildings.Fluid.HeatPumps.Data;
package WatertoWater_HeatPump "WaterToWaterHeatPump"
  extends Modelica.Icons.MaterialPropertiesPackage;

record Trane_Axiom_EXW240_70kW "Record water to water heat pump"
 extends Modelica.Icons.Record;
/*
extends Fluids.HeatPumps.Data.WatertoWater_HeatPump.Generic_EquationFit(

mCon_flow_nominal = 30/15850, 
mEva_flow_nominal = 30/15850,
Power_nominal= 18300,
Tref = 273.15+10,

 HeatQLoadCoeff={-4.23,-1.24,6.28,0.01,0.08},
 HeatPowerCoeff={-5.55,5.08,1.01,-0.04,0.00});

*/
 annotation (
  defaultComponentName="datHP",
  defaultComponentPrefixes="parameter",
  Documentation(info=
                 "<html>
Performance data for HeatPump model.
This data corresponds to the following Trane-Axiom_EXW240 model:
<pre>
HeatPump:WatertoWater,
    Trane EXW 70kW/4.11COP,  !- Name
    70000,                   !- Reference Capacity {W}
    4.11,                    !- Reference COP {W/W}
    8.89,                    !- Reference Entering Chilled Water Temperature {C}
    26.67,                   !- Reference Leaving Condenser Fluid Temperature {C}
    0.01035,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01924,                 !- Reference Condenser Water Flow Rate {m3/s}
    HeatPump WatertoWater Trane EXW 70kW/4.11COP HLR,  !- Heating Load Ratio Function of Temperature Curve Name
    HeatPump:WatertoWater Trane EXW 70kW/4.11COP PowR, !- Electric Input to nominal electric input Ratio Function of Temperature Curve Name
    
    0.10,                    !- Minimum Part Load Ratio
    1.15,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.10,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    WaterCooled,             !- Condenser Type
    ,                        !- Condenser Fan Power Ratio {W/W}
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));


end Trane_Axiom_EXW240_70kW;

  record Generic_EquationFit
  extends Modelica.Icons.Record;

    /*
  
 parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal "Reference capacity";

 parameter Modelica.SIunits.Efficiency   COP_nominal
    "Reference coefficient of performance";
 


 //parameter Real etaMotor(min=0, max=1)  "Fraction of compressor motor heat entering refrigerant";

 parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow at Condenser"
     annotation (Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
    "Nominal mass flow at Evaorator"
     annotation (Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.Temperature TRef
 "Reference temperature"
    annotation (Dialog(group="Nominal condition"));
 
 parameter Modelica.SIunits.Temperature TEvaEnt"Entering Evaorator temperature"
    annotation (Dialog(group="Performance curves"));
  
  
  
  
  

constant Integer nHLR "Number of coefficients for HLR "
   annotation (Dialog(group="Performance curves"));
   
   constant Integer nPowR "Number of coefficients for PowR"
 annotation (Dialog(group="Performance curves"));
 
 
 //  final parameter Real PLRMax=1.15                "Maximum part load ratio";
//  final parameter Real PLRMinUnl=0.1              "Minimum part unload ratio";
//  final parameter Real PLRMin=0.1                 "Minimum part load ratio";
  
  */
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end Generic_EquationFit;
end WatertoWater_HeatPump;
