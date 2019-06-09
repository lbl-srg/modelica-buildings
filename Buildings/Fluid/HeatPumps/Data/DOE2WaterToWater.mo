within Buildings.Fluid.HeatPumps.Data;
package DOE2WaterToWater
  extends Modelica.Icons.MaterialPropertiesPackage;


    record Generic "DOE2WaterToWater"
       extends Modelica.Icons.Record;
       parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal "Reference capacity";

       parameter Modelica.SIunits.Efficiency   COP_nominal;

       parameter Real PLRMax=1.15
     "Maximum part load ratio";
       parameter Real PLRMinUnl=0.1
      "Minimum part unload ratio";
       parameter Real PLRMin=0.1
      "Minimum part load ratio";
       parameter Real etaMotor
     "Fraction of compressor motor heat entering refrigerant";

       parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
      "Nominal mass flow at Condenser"
       annotation (Dialog(group="Nominal condition"));

       parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
      "Nominal mass flow at Evaorator"
       annotation (Dialog(group="Nominal condition"));

       parameter Modelica.SIunits.Temperature TConEnt_nominal
        "Temperature of fluid entering condenser at nominal condition"
        annotation (Dialog(group="Nominal condition"));

       parameter Modelica.SIunits.Temperature TEvaLvg_nominal
        "Temperature of fluid leaving condenser at nominal condition"
        annotation (Dialog(group="Nominal condition"));

       parameter Modelica.SIunits.Temperature TConEntMin
        "Minimum temperature of fluid entering condenser at nominal condition"
        annotation (Dialog(group="Nominal condition"));

       parameter Modelica.SIunits.Temperature TConEntMax
        "Maximum temperature of fluid entering condenser at nominal condition"
        annotation (Dialog(group="Nominal condition"));

       parameter Modelica.SIunits.Temperature TEvaLvgMax
        "Maximum temperature of fluid leaving evaporator  at nominal condition"
        annotation (Dialog(group="Nominal condition"));
       parameter Modelica.SIunits.Temperature TEvaLvgMin
        "Minimum temperature of fluid leaving evaporator  at nominal condition"
        annotation (Dialog(group="Nominal condition"));

       constant Integer nCapFunT=6
        "Number of coefficients for capFunT"
       annotation (Dialog(group="Performance curves"));
       constant Integer nEIRFunT=6
        "Number of coefficients for EIRFunT"
       annotation (Dialog(group="Performance curves"));
       constant Integer nEIRFunPLR=3
        "Number of coefficients for EIRFunPLR"
       annotation (Dialog(group="Performance curves"));

       parameter Real capFunT[nCapFunT]
       "Biquadratic coefficients for capFunT"
     annotation (Dialog(group="Performance curves"));
       parameter Real EIRFunT[nEIRFunT]
         "Biquadratic coefficients for EIRFunT"
     annotation (Dialog(group="Performance curves"));
       parameter Real EIRFunPLR[nEIRFunPLR]
        "Coefficients for EIRFunPLR"
     annotation (Dialog(group="Performance curves"));

       annotation (Dialog(group="Nominal condition"),
                    Dialog(group="Nominal condition"),
              Dialog(group="Nominal condition"),
     defaultComponentName="datHeaPum",
     preferredView="info",
      Documentation(info=
                      "<html>
 
 <p>This record is used as a template for performance data
 for the DOE2 water to waterchiller model
<a href=\"Buildings.Fluid.HeatPumps.DOE2WaterToWater\">
BBuildings.Fluid.HeatPumps.DOE2WaterToWater</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 6, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
     Icon(graphics={
         Text(
           extent={{-95,53},{-12,-2}},
           lineColor={0,0,255},
          textString="QCon_nominal"),
         Text(
           extent={{-95,-9},{-8,-46}},
           lineColor={0,0,255},
          textString="COP_nominal"),
         Text(
           extent={{-97,-45},{-4,-102}},
           lineColor={0,0,255},
          textString="TConLvg_nominal")}));
    end Generic;

  record ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes =
    Buildings.Fluid.HeatPumps.Data.DOE2WaterToWater.Generic (
      QEva_flow_nominal =  -471200,
      COP_nominal =         5.89,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.15,
      mEva_flow_nominal =   1000 * 0.01035,
      mCon_flow_nominal =   1000 * 0.01924,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {2.521130E-01,1.324053E-02,-8.637329E-03,8.581056E-02,-4.261176E-03,8.661899E-03},
      EIRFunT =             {4.475238E-01,-2.588210E-02,-1.459053E-03,4.342595E-02,-1.000651E-03,1.920106E-03},
      EIRFunPLR =           {2.778889E-01,2.338363E-01,4.883748E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay WSC 471kW/5.89COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay WSC 471kW/5.89COP/Vanes,  !- Name
    471200,                  !- Reference Capacity {W}
    5.89,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01035,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01924,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay WSC 471kW/5.89COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 471kW/5.89COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 471kW/5.89COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
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
  record ElectricEIRChiller_Carrier_19XL_1674kW_7_89COP_Vanes =
    Buildings.Fluid.HeatPumps.Data.DOE2WaterToWater.Generic (
      QEva_flow_nominal =  -1673900,
      COP_nominal =         7.89,
      PLRMin =              0.32,
      PLRMinUnl =           0.32,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {2.925408E-01,-4.406182E-02,-1.292074E-03,9.008701E-02,-2.646719E-03,3.388396E-03},
      EIRFunT =             {9.868510E-01,-6.325526E-02,3.498632E-03,1.699731E-02,2.573490E-04,-4.233553E-04},
      EIRFunPLR =           {3.386410E-01,2.621224E-01,3.987109E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes,  !- Name
    1673900,                 !- Reference Capacity {W}
    7.89,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.32,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.32,                    !- Minimum Unloading Ratio
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
end DOE2WaterToWater;
