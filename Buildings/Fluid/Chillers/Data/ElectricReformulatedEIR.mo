within Buildings.Fluid.Chillers.Data;
package ElectricReformulatedEIR "Performance data for chiller ElectricReformulatedEIR"
  extends Modelica.Icons.MaterialPropertiesPackage;
  record Generic "Generic data record for chiller ElectricReformulatedEIR"
    extends Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
        final nCapFunT=6,
        final nEIRFunT=6,
        final nEIRFunPLR=10);
    parameter Modelica.Units.SI.Temperature TConLvg_nominal
      "Temperature of fluid leaving condenser at nominal condition";

    parameter Modelica.Units.SI.Temperature TConLvgMin
      "Minimum value for leaving condenser temperature"
      annotation (Dialog(group="Performance curves"));
    Modelica.Units.SI.Temperature TConLvgMax
      "Maximum value for leaving condenser temperature"
      annotation (Dialog(group="Performance curves"));

    annotation (
      defaultComponentName="datChi",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
This record is used as a template for performance data
for the chiller model
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>.
To provide performance data for
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>, use
<a href=\"modelica://Buildings.Fluid.Chillers.Data.ElectricEIR.Generic\">
Buildings.Fluid.Chillers.Data.ElectricEIR.Generic</a> instead.
</html>", revisions="<html>
<ul>
<li>
December 19, 2014 by Michael Wetter:<br/>
Added <code>defaultComponentName</code> and <code>defaultComponentPrefixes</code>.
</li><li>
September 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record ReformEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -471200,
      COP_nominal =         5.89,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.08,
      mEva_flow_nominal =   1000 * 0.01035,
      mCon_flow_nominal =   1000 * 0.01924,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 33.52,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 18.81,
      TConLvgMax =          273.15 + 35.09,
      capFunT =             {-4.862465E-01,-7.293218E-02,-8.514849E-03,1.463106E-01,-4.474066E-03,9.813408E-03},
      EIRFunT =             {3.522647E-01,-3.311790E-02,-1.374491E-04,3.469525E-02,-3.624458E-04,6.749423E-04},
      EIRFunPLR =           {8.215998E-01,-2.209969E-02,-1.725652E-05,-3.831448E-02,1.896948E-01,2.308518E-02,0.000000E+00,1.349969E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay WSC 471kW/5.89COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_563kW_10_61COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -562600,
      COP_nominal =         10.61,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.01514,
      mCon_flow_nominal =   1000 * 0.0241,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 18.89,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 18.47,
      TConLvgMax =          273.15 + 33.52,
      capFunT =             {-2.841837E-01,-1.006253E-01,-3.157589E-03,1.221758E-01,-3.003466E-03,6.704017E-03},
      EIRFunT =             {-5.308783E-01,-8.364102E-02,-4.054970E-03,1.347115E-01,-1.805617E-03,3.054789E-03},
      EIRFunPLR =           {4.931998E+00,-2.128161E-01,3.520769E-04,-8.586753E+00,1.375722E+01,1.940510E-01,0.000000E+00,-8.859038E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 563kW/10.61COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 563kW/10.61COP/Vanes,  !- Name
    562600,                  !- Reference Capacity {W}
    10.61,                   !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    18.89,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01514,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0241,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 563kW/10.61COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 563kW/10.61COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 563kW/10.61COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_703kW_7_03COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -703300,
      COP_nominal =         7.03,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.02019,
      mCon_flow_nominal =   1000 * 0.02902,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.40,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.28,
      TConLvgMax =          273.15 + 31.25,
      capFunT =             {-1.336180E-01,6.473161E-02,-1.240446E-02,9.425649E-02,-2.958871E-03,5.765503E-03},
      EIRFunT =             {8.177961E-01,-1.756394E-01,2.510719E-03,2.677783E-02,-4.926551E-04,4.559008E-03},
      EIRFunPLR =           {2.342644E+00,-1.060883E-01,2.710155E-04,-2.289108E+00,3.338339E+00,9.221626E-02,0.000000E+00,-2.217954E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 703kW/7.03COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 703kW/7.03COP/Vanes,  !- Name
    703300,                  !- Reference Capacity {W}
    7.03,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.40,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02019,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.02902,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 703kW/7.03COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 703kW/7.03COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 703kW/7.03COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_724kW_6_04COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -724400,
      COP_nominal =         6.04,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.01779,
      mCon_flow_nominal =   1000 * 0.01956,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 22.12,
      TConLvgMax =          273.15 + 35.40,
      capFunT =             {-1.116010E-01,-1.058351E-01,-1.829692E-03,9.677921E-02,-2.169221E-03,4.998660E-03},
      EIRFunT =             {5.899136E-01,1.976846E-02,8.755088E-04,-7.564222E-03,8.775130E-04,-2.036856E-03},
      EIRFunPLR =           {3.645490E-01,2.732140E-03,-5.356774E-05,1.212025E-01,5.491750E-01,2.083941E-04,0.000000E+00,-7.516191E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 724kW/6.04COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 724kW/6.04COP/Vanes,  !- Name
    724400,                  !- Reference Capacity {W}
    6.04,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.44,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01779,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01956,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 724kW/6.04COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 724kW/6.04COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 724kW/6.04COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_742kW_5_42COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -742000,
      COP_nominal =         5.42,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.01779,
      mCon_flow_nominal =   1000 * 0.01956,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.86,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 22.11,
      TConLvgMax =          273.15 + 34.90,
      capFunT =             {7.769438E-01,-2.149731E-02,-1.080097E-03,2.754266E-02,-7.938947E-04,1.666375E-03},
      EIRFunT =             {1.131963E+00,-4.201196E-02,7.571267E-04,-2.042484E-02,7.676570E-04,-2.753302E-04},
      EIRFunPLR =           {4.301853E-02,1.740092E-02,-2.733344E-05,-5.445504E-01,2.155307E+00,-1.600200E-02,0.000000E+00,-6.716912E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 742kW/5.42COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 742kW/5.42COP/VSD,  !- Name
    742000,                  !- Reference Capacity {W}
    5.42,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.86,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01779,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01956,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 742kW/5.42COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 742kW/5.42COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 742kW/5.42COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_WSC_816kW_6_74COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -815800,
      COP_nominal =         6.74,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.01748,
      mCon_flow_nominal =   1000 * 0.04164,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 32.05,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.41,
      TConLvgMax =          273.15 + 33.45,
      capFunT =             {9.237537E-01,1.013316E-02,-6.564312E-03,2.744234E-02,-2.183256E-03,6.537972E-03},
      EIRFunT =             {7.251890E-01,-1.477434E-02,-3.174328E-03,4.035136E-03,-6.105556E-05,2.003152E-03},
      EIRFunPLR =           {5.166838E-01,-1.114911E-02,7.372985E-05,-7.182393E-02,8.180601E-01,7.638243E-03,0.000000E+00,-2.216516E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay WSC 816kW/6.74COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay WSC 816kW/6.74COP/Vanes,  !- Name
    815800,                  !- Reference Capacity {W}
    6.74,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    32.05,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01748,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04164,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay WSC 816kW/6.74COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 816kW/6.74COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 816kW/6.74COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_819kW_8_11COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -819300,
      COP_nominal =         8.11,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.02524,
      mCon_flow_nominal =   1000 * 0.03785,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 18.59,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.51,
      TConLvgMax =          273.15 + 35.07,
      capFunT =             {5.519141E-01,1.393287E-02,-4.818082E-03,3.705684E-02,-1.429769E-03,3.473993E-03},
      EIRFunT =             {4.447588E-01,-3.185710E-02,-8.260575E-04,3.712567E-02,-4.887950E-05,4.978770E-04},
      EIRFunPLR =           {1.038400E-01,1.702895E-02,-1.399515E-05,-9.140769E-03,1.077987E+00,-1.633517E-02,0.000000E+00,-1.811897E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 819kW/8.11COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 819kW/8.11COP/Vanes,  !- Name
    819300,                  !- Reference Capacity {W}
    8.11,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    18.59,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02524,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03785,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 819kW/8.11COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 819kW/8.11COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 819kW/8.11COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_823kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -822900,
      COP_nominal =         6.28,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04744,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.70,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 17.99,
      TConLvgMax =          273.15 + 29.36,
      capFunT =             {3.746558E-01,8.556337E-02,-3.020882E-03,3.745436E-02,-9.995050E-04,-4.477637E-05},
      EIRFunT =             {9.280652E-01,3.277907E-02,7.583449E-04,-2.536152E-02,1.204136E-03,-2.475422E-03},
      EIRFunPLR =           {1.057586E-01,1.472161E-02,-5.875508E-05,6.780787E-01,-6.310911E-02,-1.207949E-02,0.000000E+00,2.498837E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 823kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 823kW/6.28COP/Vanes,  !- Name
    822900,                  !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.70,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04744,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 823kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 823kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 823kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_869kW_5_57COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -868600,
      COP_nominal =         5.57,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.01754,
      mCon_flow_nominal =   1000 * 0.02593,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 36.12,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 22.63,
      TConLvgMax =          273.15 + 36.94,
      capFunT =             {5.989856E-01,1.069929E-01,-8.442248E-03,-1.622083E-03,-4.384385E-04,2.372388E-03},
      EIRFunT =             {5.173193E-01,7.303695E-02,-7.486318E-03,-2.613352E-03,1.000039E-04,1.264598E-03},
      EIRFunPLR =           {1.317677E-01,-7.501960E-03,5.073000E-06,8.550743E-01,-6.215987E-01,7.267902E-03,0.000000E+00,6.373549E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 869kW/5.57COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 869kW/5.57COP/VSD,  !- Name
    868600,                  !- Reference Capacity {W}
    5.57,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    36.12,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01754,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.02593,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 869kW/5.57COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 869kW/5.57COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 869kW/5.57COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_897kW_7_23COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         7.23,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.0436,
      TEvaLvg_nominal =     273.15 + 9.82,
      TConLvg_nominal =     273.15 + 29.49,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 18.72,
      TConLvgMax =          273.15 + 30.41,
      capFunT =             {5.211989E-01,7.968670E-02,-1.488365E-03,1.974850E-02,-4.643458E-04,-7.786719E-04},
      EIRFunT =             {6.970381E-01,5.701647E-02,-2.272629E-04,8.496805E-03,4.752264E-04,-2.759799E-03},
      EIRFunPLR =           {7.280764E-01,-5.949776E-02,3.161338E-05,8.871893E-01,-1.081399E+00,5.804626E-02,0.000000E+00,4.825053E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 897kW/7.23COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 897kW/7.23COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    7.23,                    !- Reference COP {W/W}
    9.82,                    !- Reference Leaving Chilled Water Temperature {C}
    29.49,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0436,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 897kW/7.23COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 897kW/7.23COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 897kW/7.23COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_897kW_6_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         6.50,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04423,
      TEvaLvg_nominal =     273.15 + 9.82,
      TConLvg_nominal =     273.15 + 29.49,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 18.06,
      TConLvgMax =          273.15 + 29.67,
      capFunT =             {5.761951E-01,5.897243E-03,-8.764033E-04,3.207348E-02,-1.225175E-03,2.019768E-03},
      EIRFunT =             {9.192535E-01,9.218992E-03,1.241236E-03,-1.554079E-02,1.074639E-03,-2.071288E-03},
      EIRFunPLR =           {-5.497250E-01,5.035076E-02,-1.927855E-05,1.678371E+00,-1.535993E+00,-4.944902E-02,0.000000E+00,1.396972E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 897kW/6.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 897kW/6.50COP/Vanes,  !- Name
    896700,                  !- Reference Capacity {W}
    6.50,                    !- Reference COP {W/W}
    9.82,                    !- Reference Leaving Chilled Water Temperature {C}
    29.49,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04423,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 897kW/6.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 897kW/6.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 897kW/6.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_897kW_7_60COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         7.60,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 9.83,
      TConLvg_nominal =     273.15 + 27.50,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 17.28,
      TConLvgMax =          273.15 + 28.76,
      capFunT =             {3.548168E-01,3.801839E-03,-2.081058E-03,5.549806E-02,-2.238902E-03,3.723197E-03},
      EIRFunT =             {4.207123E-01,5.394605E-05,-3.910848E-04,4.180526E-02,-1.982304E-04,-1.128927E-03},
      EIRFunPLR =           {-1.019329E+00,8.590218E-02,-1.293139E-04,7.442374E-01,2.883061E-02,-8.027926E-02,0.000000E+00,1.185988E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 897kW/7.60COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 897kW/7.60COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    7.60,                    !- Reference COP {W/W}
    9.83,                    !- Reference Leaving Chilled Water Temperature {C}
    27.50,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 897kW/7.60COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 897kW/7.60COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 897kW/7.60COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_897kW_6_27COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         6.27,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 27.61,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 17.59,
      TConLvgMax =          273.15 + 29.04,
      capFunT =             {-1.279200E-01,1.653602E-01,-4.202474E-03,4.807512E-02,-9.553549E-04,-2.146733E-03},
      EIRFunT =             {3.276702E-01,-7.003986E-02,5.261779E-03,7.021494E-02,-7.368698E-04,-2.109336E-03},
      EIRFunPLR =           {-3.773762E-02,1.134114E-02,-2.659425E-05,2.639446E-01,4.805824E-01,-1.117502E-02,0.000000E+00,3.000515E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 897kW/6.27COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 897kW/6.27COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    6.27,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    27.61,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 897kW/6.27COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 897kW/6.27COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 897kW/6.27COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_897kW_6_23COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         6.23,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04442,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 29.49,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 18.61,
      TConLvgMax =          273.15 + 30.29,
      capFunT =             {8.691024E-01,2.885812E-02,1.795420E-04,4.868722E-03,-3.207870E-04,3.825044E-04},
      EIRFunT =             {8.640049E-01,5.766109E-03,1.197122E-03,-2.312809E-03,4.642915E-04,-1.375629E-03},
      EIRFunPLR =           {9.617997E-01,-8.158350E-02,-5.841564E-06,1.169179E+00,-1.600491E+00,8.176055E-02,0.000000E+00,4.684331E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 897kW/6.23COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 897kW/6.23COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    6.23,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.49,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04442,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 897kW/6.23COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 897kW/6.23COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 897kW/6.23COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PFH_932kW_5_09COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -931900,
      COP_nominal =         5.09,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 31.75,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 19.66,
      TConLvgMax =          273.15 + 35.59,
      capFunT =             {1.021236E+00,-1.680220E-03,-5.223075E-03,2.922245E-02,-1.418909E-03,4.211341E-03},
      EIRFunT =             {4.854031E-01,-1.891596E-02,-1.236212E-03,1.975021E-02,-1.031869E-04,6.964845E-04},
      EIRFunPLR =           {7.391619E-03,9.094277E-03,-7.116487E-06,1.699487E-01,1.518580E+00,-8.713759E-03,0.000000E+00,-7.007499E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PFH 932kW/5.09COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PFH 932kW/5.09COP/Vanes,  !- Name
    931900,                  !- Reference Capacity {W}
    5.09,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    31.75,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PFH 932kW/5.09COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 932kW/5.09COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 932kW/5.09COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_960kW_4_64COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -960000,
      COP_nominal =         4.64,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.1,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 32.01,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 17.04,
      TConLvgMax =          273.15 + 35.78,
      capFunT =             {-3.474613E-01,4.071500E-01,-3.270717E-02,1.187286E-02,-3.117876E-04,5.854731E-04},
      EIRFunT =             {6.522319E-01,-1.649356E-02,2.777675E-04,3.580800E-03,3.253181E-04,-2.452307E-04},
      EIRFunPLR =           {3.303041E-01,-1.499923E-03,4.911711E-06,3.166646E-01,4.011833E-01,1.242191E-03,0.000000E+00,-4.559734E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 960kW/4.64COP/Vanes"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 960kW/4.64COP/Vanes,  !- Name
    960000,                  !- Reference Capacity {W}
    4.64,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    32.01,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 960kW/4.64COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 960kW/4.64COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 960kW/4.64COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.1,                     !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1023kW_5_81COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1023300,
      COP_nominal =         5.81,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.02366,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 35.51,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.34,
      TConLvgMax =          273.15 + 40.55,
      capFunT =             {-3.395788E-01,-3.084319E-02,-5.520572E-03,1.112148E-01,-2.662980E-03,5.099892E-03},
      EIRFunT =             {6.129429E-01,-1.403780E-02,1.331529E-03,-2.182097E-04,5.502817E-04,-1.092920E-03},
      EIRFunPLR =           {2.511511E-01,8.555669E-03,-3.399815E-05,-2.271964E-01,1.450679E+00,-6.729414E-03,0.000000E+00,-4.981512E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1023kW/5.81COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1023kW/5.81COP/Vanes,  !- Name
    1023300,                 !- Reference Capacity {W}
    5.81,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    35.51,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02366,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1023kW/5.81COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1023kW/5.81COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1023kW/5.81COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_1030kW_8_58COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1030300,
      COP_nominal =         8.58,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.02378,
      mCon_flow_nominal =   1000 * 0.03407,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 20.86,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 20.86,
      TConLvgMax =          273.15 + 32.69,
      capFunT =             {6.367679E-01,2.637864E-02,-4.503997E-03,2.614644E-02,-1.509627E-03,3.809305E-03},
      EIRFunT =             {5.347930E-01,-1.901560E-03,-1.999168E-03,2.601989E-02,-1.174414E-04,4.209479E-04},
      EIRFunPLR =           {3.869427E-01,-1.316341E-03,4.231383E-05,-9.777673E-02,8.539824E-01,-7.526877E-04,0.000000E+00,-1.180591E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 1030kW/8.58COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 1030kW/8.58COP/Vanes,  !- Name
    1030300,                 !- Reference Capacity {W}
    8.58,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    20.86,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02378,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03407,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 1030kW/8.58COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1030kW/8.58COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1030kW/8.58COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1048kW_6_06COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1047900,
      COP_nominal =         6.06,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.04542,
      mCon_flow_nominal =   1000 * 0.05678,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.59,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.43,
      TConLvgMax =          273.15 + 39.72,
      capFunT =             {5.846663E-01,1.059863E-02,-5.058695E-03,3.006085E-02,-9.364366E-04,2.597223E-03},
      EIRFunT =             {7.745270E-01,-3.256346E-02,2.992117E-03,-5.274460E-03,6.701377E-04,-1.236258E-03},
      EIRFunPLR =           {5.753623E-01,-1.409335E-02,-5.983885E-06,6.063425E-01,-3.090569E-01,1.412467E-02,0.000000E+00,1.296066E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1048kW/6.06COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1048kW/6.06COP/Vanes,  !- Name
    1047900,                 !- Reference Capacity {W}
    6.06,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.59,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04542,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05678,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1048kW/6.06COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1048kW/6.06COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1048kW/6.06COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1055kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1055000,
      COP_nominal =         5.96,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.02839,
      mCon_flow_nominal =   1000 * 0.05678,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.63,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.24,
      TConLvgMax =          273.15 + 39.89,
      capFunT =             {-2.707500E-01,-6.904583E-02,-2.862217E-03,1.116660E-01,-2.741006E-03,5.573759E-03},
      EIRFunT =             {5.864611E-01,-1.981483E-02,1.189656E-03,4.468905E-03,4.366968E-04,-7.679079E-04},
      EIRFunPLR =           {2.585491E-01,8.250769E-03,-3.231494E-05,-8.921620E-02,1.025668E+00,-6.495267E-03,0.000000E+00,-2.179388E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1055kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1055kW/5.96COP/Vanes,  !- Name
    1055000,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.63,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02839,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05678,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1055kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1055kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1055kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1076kW_5_52COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1076100,
      COP_nominal =         5.52,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04744,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.30,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 19.50,
      TConLvgMax =          273.15 + 32.15,
      capFunT =             {8.850533E-01,2.837149E-02,-5.511387E-03,8.194635E-03,-6.603948E-04,2.956238E-03},
      EIRFunT =             {7.658820E-01,1.245831E-02,-4.811737E-03,-2.449180E-03,1.633990E-04,1.270390E-03},
      EIRFunPLR =           {-4.774361E-01,5.162751E-02,-5.614109E-05,-2.035828E-01,1.353459E+00,-4.892949E-02,0.000000E+00,2.956492E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes,  !- Name
    1076100,                 !- Reference Capacity {W}
    5.52,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.30,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04744,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1080kW_7_39COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1079600,
      COP_nominal =         7.39,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.06416,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.18,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 20.34,
      TConLvgMax =          273.15 + 28.77,
      capFunT =             {1.621590E-01,-5.637755E-02,-2.763571E-03,7.658390E-02,-2.167501E-03,4.940163E-03},
      EIRFunT =             {2.583099E-01,-5.295487E-02,5.742775E-05,3.724845E-02,-1.705687E-04,7.265593E-04},
      EIRFunPLR =           {-2.528901E-01,5.293978E-02,-1.671838E-05,-7.241218E-02,1.197879E+00,-5.205361E-02,0.000000E+00,1.156312E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1080kW/7.39COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1080kW/7.39COP/Vanes,  !- Name
    1079600,                 !- Reference Capacity {W}
    7.39,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.18,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06416,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1080kW/7.39COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1080kW/7.39COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1080kW/7.39COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1090kW_7_57COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1090100,
      COP_nominal =         7.57,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 28.52,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 19.00,
      TConLvgMax =          273.15 + 30.79,
      capFunT =             {5.432784E-01,4.854908E-02,-8.778732E-04,2.814444E-02,-9.314140E-04,8.240584E-04},
      EIRFunT =             {8.635874E-01,-6.482460E-02,-2.524813E-04,2.842929E-02,-4.007377E-04,1.830138E-03},
      EIRFunPLR =           {-1.594094E+00,1.294337E-01,-2.100100E-04,1.659018E+00,-2.605622E+00,-1.199783E-01,0.000000E+00,3.435191E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1090kW/7.57COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1090kW/7.57COP/VSD,  !- Name
    1090100,                 !- Reference Capacity {W}
    7.57,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    28.52,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1090kW/7.57COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1090kW/7.57COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1090kW/7.57COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_1104kW_8_00COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1104200,
      COP_nominal =         8.00,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.02423,
      mCon_flow_nominal =   1000 * 0.03028,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 22.59,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 22.59,
      TConLvgMax =          273.15 + 34.29,
      capFunT =             {7.757836E-01,1.723720E-02,-2.761789E-03,1.560171E-02,-1.133168E-03,3.042701E-03},
      EIRFunT =             {7.355874E-01,-1.291195E-02,-1.168928E-03,1.454443E-02,-4.975714E-06,4.941841E-04},
      EIRFunPLR =           {2.216357E-01,6.972382E-03,5.022616E-05,-3.939145E-02,9.582611E-01,-9.691500E-03,0.000000E+00,-1.039758E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 1104kW/8.00COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 1104kW/8.00COP/Vanes,  !- Name
    1104200,                 !- Reference Capacity {W}
    8.00,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    22.59,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02423,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03028,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 1104kW/8.00COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1104kW/8.00COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1104kW/8.00COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1125kW_4_89COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1125300,
      COP_nominal =         4.89,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.02776,
      mCon_flow_nominal =   1000 * 0.02618,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 36.27,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 26.10,
      TConLvgMax =          273.15 + 36.56,
      capFunT =             {3.738655E-01,-1.966419E-02,-1.212112E-03,3.549468E-02,-5.800042E-04,1.250514E-03},
      EIRFunT =             {4.744658E-01,-3.998991E-02,-8.170569E-05,1.686296E-02,8.315397E-05,1.607491E-04},
      EIRFunPLR =           {3.526188E-01,-2.052741E-03,5.127782E-06,-3.558764E-01,1.168571E+00,1.752891E-03,0.000000E+00,-1.609826E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1125kW/4.89COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1125kW/4.89COP/Vanes,  !- Name
    1125300,                 !- Reference Capacity {W}
    4.89,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    36.27,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02776,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.02618,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1125kW/4.89COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1125kW/4.89COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1125kW/4.89COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1125kW_7_92COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1125300,
      COP_nominal =         7.92,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03243,
      mCon_flow_nominal =   1000 * 0.05173,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 18.64,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 18.64,
      TConLvgMax =          273.15 + 31.75,
      capFunT =             {-1.825851E-01,-1.890742E-02,-1.452495E-03,9.494132E-02,-2.160634E-03,2.833148E-03},
      EIRFunT =             {6.772525E-01,-1.573620E-02,1.805356E-03,2.061048E-02,5.587604E-04,-2.014421E-03},
      EIRFunPLR =           {3.110875E-01,-5.972965E-03,-8.888194E-05,-5.317766E-01,1.932563E+00,1.040312E-02,0.000000E+00,-7.660775E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1125kW/7.92COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1125kW/7.92COP/VSD,  !- Name
    1125300,                 !- Reference Capacity {W}
    7.92,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    18.64,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03243,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05173,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1125kW/7.92COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1125kW/7.92COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1125kW/7.92COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1129kW_7_19COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1128800,
      COP_nominal =         7.19,
      PLRMin =              0.15,
      PLRMinUnl =           0.15,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.02776,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.87,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 20.75,
      TConLvgMax =          273.15 + 30.64,
      capFunT =             {4.234935E-02,-6.711406E-02,-2.677761E-03,8.534835E-02,-2.240897E-03,5.028453E-03},
      EIRFunT =             {2.480712E-01,-5.163331E-02,-3.517164E-04,3.943482E-02,-3.224045E-04,9.124398E-04},
      EIRFunPLR =           {2.681887E-01,-1.329414E-03,-1.542108E-05,5.321500E-01,-2.230911E-01,2.236942E-03,0.000000E+00,4.101272E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1129kW/7.19COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1129kW/7.19COP/Vanes,  !- Name
    1128800,                 !- Reference Capacity {W}
    7.19,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.87,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02776,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1129kW/7.19COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1129kW/7.19COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1129kW/7.19COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.15,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.15,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1143kW_6_57COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1142900,
      COP_nominal =         6.57,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.02593,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 10.00,
      TConLvg_nominal =     273.15 + 32.79,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.02,
      TConLvgMax =          273.15 + 33.61,
      capFunT =             {7.863855E-01,3.259744E-02,-1.927704E-03,4.333411E-03,-6.022390E-04,1.809424E-03},
      EIRFunT =             {9.612126E-01,-1.211702E-02,1.782802E-04,-2.807827E-03,2.421828E-04,1.165934E-05},
      EIRFunPLR =           {-1.922490E-02,1.026695E-02,-3.079249E-05,1.432686E-01,4.844691E-01,-8.952298E-03,0.000000E+00,3.774796E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1143kW/6.57COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1143kW/6.57COP/VSD,  !- Name
    1142900,                 !- Reference Capacity {W}
    6.57,                    !- Reference COP {W/W}
    10.00,                   !- Reference Leaving Chilled Water Temperature {C}
    32.79,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02593,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1143kW/6.57COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1143kW/6.57COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1143kW/6.57COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1157kW_5_62COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1156900,
      COP_nominal =         5.62,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.02801,
      mCon_flow_nominal =   1000 * 0.03186,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.34,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 21.97,
      TConLvgMax =          273.15 + 34.50,
      capFunT =             {1.095494E+00,-5.546137E-03,-5.186584E-04,1.420446E-03,-2.801603E-04,1.007864E-03},
      EIRFunT =             {1.221566E+00,-2.771462E-02,1.220059E-03,-2.228215E-02,7.578438E-04,-8.532836E-04},
      EIRFunPLR =           {2.260949E-01,-1.619690E-02,2.953765E-06,4.956395E-01,1.180777E-01,1.582337E-02,0.000000E+00,1.675772E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1157kW/5.62COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1157kW/5.62COP/VSD,  !- Name
    1156900,                 !- Reference Capacity {W}
    5.62,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.34,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02801,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03186,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1157kW/5.62COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1157kW/5.62COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1157kW/5.62COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1196kW_6_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1195600,
      COP_nominal =         6.50,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03426,
      mCon_flow_nominal =   1000 * 0.04252,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 31.65,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 21.72,
      TConLvgMax =          273.15 + 33.03,
      capFunT =             {1.006647E+00,-3.596242E-02,-2.549306E-03,2.690324E-02,-1.255051E-03,3.669880E-03},
      EIRFunT =             {1.001094E+00,-1.641469E-02,3.314844E-04,-1.095655E-02,5.687863E-04,-4.694134E-04},
      EIRFunPLR =           {1.659565E-01,2.824668E-03,-4.941235E-05,9.544016E-01,-7.843794E-01,-1.991887E-04,0.000000E+00,6.294448E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes,  !- Name
    1195600,                 !- Reference Capacity {W}
    6.50,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    31.65,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03426,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04252,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1213kW_7_78COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1213200,
      COP_nominal =         7.78,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03243,
      mCon_flow_nominal =   1000 * 0.04782,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 19.63,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.63,
      TConLvgMax =          273.15 + 30.97,
      capFunT =             {7.578317E-01,-2.467497E-02,-1.185171E-03,3.095499E-02,-1.160103E-03,2.330164E-03},
      EIRFunT =             {1.009816E+00,-1.640134E-02,7.295439E-04,-5.050832E-03,6.901476E-04,-9.104064E-04},
      EIRFunPLR =           {2.257912E-01,3.697616E-03,-2.645195E-05,7.936322E-01,-4.424994E-01,-2.424456E-03,0.000000E+00,4.078706E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes,  !- Name
    1213200,                 !- Reference Capacity {W}
    7.78,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    19.63,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03243,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04782,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_1231kW_6_18COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1230800,
      COP_nominal =         6.18,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03533,
      mCon_flow_nominal =   1000 * 0.0511,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.47,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.98,
      TConLvgMax =          273.15 + 31.25,
      capFunT =             {1.253381E+00,8.875124E-02,-8.323384E-03,-1.024474E-02,-6.751294E-04,2.456063E-03},
      EIRFunT =             {8.880010E-01,-9.202757E-03,-5.021594E-03,-9.074393E-03,2.554841E-04,2.313326E-03},
      EIRFunPLR =           {1.651794E-01,-3.089335E-03,2.301100E-04,1.104907E+00,-8.157905E-01,-8.477359E-03,0.000000E+00,6.893449E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 1231kW/6.18COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 1231kW/6.18COP/Vanes,  !- Name
    1230800,                 !- Reference Capacity {W}
    6.18,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.47,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03533,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0511,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 1231kW/6.18COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1231kW/6.18COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1231kW/6.18COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1234kW_5_39COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1234300,
      COP_nominal =         5.39,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.02593,
      mCon_flow_nominal =   1000 * 0.03861,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 35.73,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 22.24,
      TConLvgMax =          273.15 + 36.28,
      capFunT =             {6.134255E-01,1.092476E-01,-7.352739E-03,-2.589985E-03,-3.793512E-04,1.839978E-03},
      EIRFunT =             {4.746375E-01,9.120326E-02,-7.295060E-03,-5.662273E-03,1.928027E-04,8.244779E-04},
      EIRFunPLR =           {1.207212E-01,-9.914826E-03,1.854918E-05,9.880331E-01,-8.955866E-01,8.894574E-03,0.000000E+00,8.005552E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1234kW/5.39COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1234kW/5.39COP/VSD,  !- Name
    1234300,                 !- Reference Capacity {W}
    5.39,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    35.73,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02593,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03861,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1234kW/5.39COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1234kW/5.39COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1234kW/5.39COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1259kW_6_26COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1258900,
      COP_nominal =         6.26,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.02593,
      mCon_flow_nominal =   1000 * 0.03823,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 35.80,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 22.61,
      TConLvgMax =          273.15 + 36.74,
      capFunT =             {1.013444E+00,-3.162384E-03,-4.418949E-03,1.601141E-02,-1.029678E-03,3.508932E-03},
      EIRFunT =             {7.661241E-01,1.157734E-02,-8.937094E-04,-6.824770E-03,5.288283E-04,-7.378113E-04},
      EIRFunPLR =           {4.602131E-02,2.433945E-02,6.394526E-05,-3.648563E-01,1.854759E+00,-2.809346E-02,0.000000E+00,-4.821515E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes,  !- Name
    1258900,                 !- Reference Capacity {W}
    6.26,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    35.80,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02593,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03823,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_1259kW_6_45COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1258900,
      COP_nominal =         6.45,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.02631,
      mCon_flow_nominal =   1000 * 0.06246,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 32.24,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.63,
      TConLvgMax =          273.15 + 32.83,
      capFunT =             {7.917669E-01,7.718144E-02,-1.868147E-03,2.168367E-02,-9.454040E-04,-1.251512E-04},
      EIRFunT =             {1.207755E+00,2.704147E-02,-1.882949E-05,-5.234106E-02,1.851447E-03,-2.375891E-03},
      EIRFunPLR =           {-3.830726E-01,3.222162E-02,7.399276E-05,3.649000E-01,1.497231E+00,-3.597905E-02,0.000000E+00,-4.321713E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 1259kW/6.45COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 1259kW/6.45COP/Vanes,  !- Name
    1258900,                 !- Reference Capacity {W}
    6.45,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    32.24,                   !- Reference Leaving Condenser Water Temperature {C}
    0.02631,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06246,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 1259kW/6.45COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 1259kW/6.45COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 1259kW/6.45COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1266kW_4_39COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1266000,
      COP_nominal =         4.39,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.03533,
      mCon_flow_nominal =   1000 * 0.05773,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 41.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.28,
      TConLvgMax =          273.15 + 42.31,
      capFunT =             {1.556501E-03,-4.410896E-02,-1.854492E-03,6.411584E-02,-1.204698E-03,3.060359E-03},
      EIRFunT =             {1.265473E-01,5.028662E-02,-4.704162E-03,7.913033E-03,3.096000E-04,-4.283498E-04},
      EIRFunPLR =           {1.253346E+00,-3.406609E-02,1.893094E-04,2.554443E-01,-1.655620E+00,2.220865E-02,0.000000E+00,1.319681E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1266kW/4.39COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1266kW/4.39COP/Vanes,  !- Name
    1266000,                 !- Reference Capacity {W}
    4.39,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    41.44,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03533,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05773,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1266kW/4.39COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1266kW/4.39COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1266kW/4.39COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1284kW_6_20COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1283500,
      COP_nominal =         6.20,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03684,
      mCon_flow_nominal =   1000 * 0.05337,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.46,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.55,
      TConLvgMax =          273.15 + 30.85,
      capFunT =             {1.115795E+00,-2.963853E-02,-1.135671E-03,4.184083E-03,-4.382921E-04,2.096512E-03},
      EIRFunT =             {7.586434E-01,-1.231609E-02,1.784584E-03,-2.678401E-03,6.302421E-04,-1.385469E-03},
      EIRFunPLR =           {9.435414E-01,-6.553709E-02,1.115089E-04,1.530548E+00,-1.486930E+00,6.031382E-02,0.000000E+00,7.320523E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes,  !- Name
    1283500,                 !- Reference Capacity {W}
    6.20,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.46,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03684,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1294kW_7_61COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1294100,
      COP_nominal =         7.61,
      PLRMin =              0.16,
      PLRMinUnl =           0.16,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03243,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 20.18,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 20.18,
      TConLvgMax =          273.15 + 31.56,
      capFunT =             {8.542077E-01,-5.459736E-03,-1.943025E-03,1.670770E-02,-9.079473E-04,2.332448E-03},
      EIRFunT =             {1.167182E+00,-4.534610E-03,-2.394329E-03,-1.568154E-02,4.922543E-04,5.971107E-04},
      EIRFunPLR =           {-2.942311E-02,2.842914E-02,-1.096497E-05,-1.072984E+00,3.343046E+00,-2.769791E-02,0.000000E+00,-1.251621E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes,  !- Name
    1294100,                 !- Reference Capacity {W}
    7.61,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    20.18,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03243,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.16,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.16,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1329kW_5_38COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1329300,
      COP_nominal =         5.38,
      PLRMin =              0.29,
      PLRMinUnl =           0.29,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.04732,
      mCon_flow_nominal =   1000 * 0.07098,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 34.80,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 26.77,
      TConLvgMax =          273.15 + 41.98,
      capFunT =             {2.971340E-01,1.063097E-01,-4.449876E-03,2.540435E-02,-5.696223E-04,1.269921E-04},
      EIRFunT =             {9.460623E-01,3.685465E-02,-7.530867E-04,-1.753701E-02,5.832929E-04,-1.143458E-03},
      EIRFunPLR =           {-9.512023E-02,8.704652E-03,-6.499682E-06,1.336749E+00,-6.968012E-01,-8.318175E-03,0.000000E+00,4.497796E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1329kW/5.38COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1329kW/5.38COP/Vanes,  !- Name
    1329300,                 !- Reference Capacity {W}
    5.38,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    34.80,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04732,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07098,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1329kW/5.38COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1329kW/5.38COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1329kW/5.38COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.29,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.29,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1350kW_7_90COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1350400,
      COP_nominal =         7.90,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03684,
      mCon_flow_nominal =   1000 * 0.05337,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 19.60,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.55,
      TConLvgMax =          273.15 + 30.85,
      capFunT =             {1.060586E+00,-2.817204E-02,-1.079479E-03,3.977058E-03,-4.166057E-04,1.992778E-03},
      EIRFunT =             {9.661627E-01,-1.568504E-02,2.272739E-03,-3.411051E-03,8.026386E-04,-1.764450E-03},
      EIRFunPLR =           {1.868582E+00,-1.412449E-01,2.563520E-04,8.432680E-01,-1.538206E+00,1.292323E-01,0.000000E+00,-3.507772E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1350kW/7.90COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1350kW/7.90COP/VSD,  !- Name
    1350400,                 !- Reference Capacity {W}
    7.90,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    19.60,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03684,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1350kW/7.90COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1350kW/7.90COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1350kW/7.90COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1368kW_7_35COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1367900,
      COP_nominal =         7.35,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.80,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.76,
      TConLvgMax =          273.15 + 34.51,
      capFunT =             {-1.988920E-01,-1.019014E-01,-4.605586E-03,1.364167E-01,-4.142785E-03,8.790965E-03},
      EIRFunT =             {1.787713E-01,-1.943742E-02,-5.155001E-03,4.314534E-02,-5.446713E-04,2.049096E-03},
      EIRFunPLR =           {-4.466479E-01,1.188856E-01,-5.385997E-05,-2.756308E+00,4.709118E+00,-1.161211E-01,0.000000E+00,-5.402852E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1368kW/7.35COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1368kW/7.35COP/VSD,  !- Name
    1367900,                 !- Reference Capacity {W}
    7.35,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.80,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1368kW/7.35COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1368kW/7.35COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1368kW/7.35COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1372kW_7_49COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1371500,
      COP_nominal =         7.49,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.11,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.80,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.87,
      TConLvgMax =          273.15 + 34.26,
      capFunT =             {3.397637E-01,3.431595E-02,-1.008753E-02,5.766544E-02,-2.300721E-03,6.035544E-03},
      EIRFunT =             {1.033692E+00,3.558404E-02,3.589722E-03,-2.717762E-02,1.379031E-03,-4.158610E-03},
      EIRFunPLR =           {4.723036E-01,8.571830E-03,4.576667E-05,-1.502847E+00,3.731872E+00,-1.107635E-02,0.000000E+00,-1.669562E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1372kW/7.49COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1372kW/7.49COP/Vanes,  !- Name
    1371500,                 !- Reference Capacity {W}
    7.49,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.80,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1372kW/7.49COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1372kW/7.49COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1372kW/7.49COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.11,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1396kW_7_35COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1396100,
      COP_nominal =         7.35,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.90,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.94,
      TConLvgMax =          273.15 + 34.67,
      capFunT =             {3.601322E-02,-9.771124E-02,-2.845248E-03,1.124508E-01,-3.477685E-03,7.688650E-03},
      EIRFunT =             {4.546708E-01,3.725193E-03,-1.145409E-04,1.695408E-02,3.224089E-04,-1.265009E-03},
      EIRFunPLR =           {-2.549993E-01,1.161730E-01,1.913023E-06,-3.306674E+00,5.813195E+00,-1.164290E-01,0.000000E+00,-1.247308E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1396kW/7.35COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1396kW/7.35COP/Vanes,  !- Name
    1396100,                 !- Reference Capacity {W}
    7.35,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.90,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1396kW/7.35COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1396kW/7.35COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1396kW/7.35COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1403kW_7_09COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1403100,
      COP_nominal =         7.09,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03426,
      mCon_flow_nominal =   1000 * 0.04252,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 21.78,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 21.77,
      TConLvgMax =          273.15 + 33.09,
      capFunT =             {8.573696E-01,-3.077045E-02,-2.171254E-03,2.296255E-02,-1.067689E-03,3.125156E-03},
      EIRFunT =             {1.172049E+00,-1.768334E-02,3.356460E-04,-1.485826E-02,6.930197E-04,-5.461447E-04},
      EIRFunPLR =           {1.386665E-01,4.836823E-03,-5.406708E-05,-4.609915E-01,2.214035E+00,-1.925694E-03,0.000000E+00,-9.302446E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1403kW/7.09COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1403kW/7.09COP/VSD,  !- Name
    1403100,                 !- Reference Capacity {W}
    7.09,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    21.78,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03426,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04252,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1403kW/7.09COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1403kW/7.09COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1403kW/7.09COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1403kW_6_94COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1403100,
      COP_nominal =         6.94,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.13,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.05047,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.50,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.33,
      TConLvgMax =          273.15 + 36.28,
      capFunT =             {-1.721714E+00,8.594308E-02,-1.220844E-02,2.037396E-01,-4.654718E-03,4.701301E-03},
      EIRFunT =             {5.348381E-01,-1.779962E-02,-4.925343E-03,1.066975E-02,9.573974E-05,1.717894E-03},
      EIRFunPLR =           {1.005500E+00,3.906974E-02,-7.721440E-06,-5.794857E+00,9.282464E+00,-3.755116E-02,0.000000E+00,-3.524493E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1403kW/6.94COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1403kW/6.94COP/VSD,  !- Name
    1403100,                 !- Reference Capacity {W}
    6.94,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.50,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05047,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1403kW/6.94COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1403kW/6.94COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1403kW/6.94COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.13,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1407kW_7_14COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1406600,
      COP_nominal =         7.14,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.96,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.66,
      TConLvgMax =          273.15 + 34.28,
      capFunT =             {1.098635E-01,-4.154795E-02,-6.348039E-03,8.801570E-02,-2.631387E-03,5.846073E-03},
      EIRFunT =             {6.391346E-01,5.159383E-02,-5.750293E-03,-9.196660E-03,7.380570E-04,-4.665422E-04},
      EIRFunPLR =           {2.754461E-01,6.701607E-02,-8.579222E-05,-4.299994E+00,7.901098E+00,-6.298243E-02,0.000000E+00,-2.924081E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1407kW/7.14COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1407kW/7.14COP/VSD,  !- Name
    1406600,                 !- Reference Capacity {W}
    7.14,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.96,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1407kW/7.14COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1407kW/7.14COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1407kW/7.14COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PFH_1407kW_6_60COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1406600,
      COP_nominal =         6.60,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.04038,
      mCon_flow_nominal =   1000 * 0.05804,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.45,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.90,
      TConLvgMax =          273.15 + 32.26,
      capFunT =             {4.857520E-01,-1.139327E-01,-1.036160E-02,1.146315E-01,-4.547626E-03,1.263077E-02},
      EIRFunT =             {9.392120E-01,3.430098E-02,-5.178425E-03,-2.274002E-02,6.827442E-04,7.649464E-04},
      EIRFunPLR =           {-6.446736E-01,5.352860E-02,1.582353E-06,2.669373E-01,1.497456E+00,-5.364380E-02,0.000000E+00,-1.183319E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PFH 1407kW/6.60COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PFH 1407kW/6.60COP/Vanes,  !- Name
    1406600,                 !- Reference Capacity {W}
    6.60,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.45,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04038,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05804,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PFH 1407kW/6.60COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 1407kW/6.60COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 1407kW/6.60COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1407kW_6_04COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1406600,
      COP_nominal =         6.04,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06057,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.63,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 18.11,
      TConLvgMax =          273.15 + 37.42,
      capFunT =             {9.006457E-01,-1.139681E-02,-1.480623E-03,2.770949E-02,-9.617215E-04,1.812986E-03},
      EIRFunT =             {1.174615E+00,-1.237741E-02,-1.147159E-03,-2.996332E-02,8.901939E-04,-2.302077E-04},
      EIRFunPLR =           {-5.839828E-01,4.640814E-02,-7.366007E-05,-1.926398E-01,2.597682E+00,-4.268655E-02,0.000000E+00,-8.666390E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1407kW/6.04COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1407kW/6.04COP/VSD,  !- Name
    1406600,                 !- Reference Capacity {W}
    6.04,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.63,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06057,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1407kW/6.04COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1407kW/6.04COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1407kW/6.04COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1410kW_8_54COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1410100,
      COP_nominal =         8.54,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04,
      mCon_flow_nominal =   1000 * 0.05861,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 19.21,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.05,
      TConLvgMax =          273.15 + 30.63,
      capFunT =             {9.053779E-01,-1.615047E-02,-1.175290E-03,1.318125E-02,-5.919239E-04,1.756836E-03},
      EIRFunT =             {1.074067E+00,-6.702565E-02,3.043272E-04,6.055739E-03,4.615039E-04,3.375766E-04},
      EIRFunPLR =           {-6.984658E-02,2.103714E-02,5.767453E-05,5.267406E-01,6.390076E-01,-2.389231E-02,0.000000E+00,-6.097179E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1410kW/8.54COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1410kW/8.54COP/VSD,  !- Name
    1410100,                 !- Reference Capacity {W}
    8.54,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    19.21,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04,                    !- Reference Chilled Water Flow Rate {m3/s}
    0.05861,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1410kW/8.54COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1410kW/8.54COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1410kW/8.54COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1441800,
      COP_nominal =         6.61,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.05047,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.76,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.72,
      TConLvgMax =          273.15 + 41.41,
      capFunT =             {-2.660651E-01,-2.114972E-02,-3.928472E-04,9.573910E-02,-2.015949E-03,2.030045E-03},
      EIRFunT =             {6.807134E-01,-2.285082E-02,8.153057E-04,9.280487E-04,4.950540E-04,-6.106817E-04},
      EIRFunPLR =           {-5.842314E-01,5.001539E-02,-1.157444E-04,-3.287848E-03,1.916917E+00,-4.340928E-02,0.000000E+00,-4.222738E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1442kW/6.61COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1442kW/6.61COP/VSD,  !- Name
    1441800,                 !- Reference Capacity {W}
    6.61,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.76,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05047,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1442kW/6.61COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1442kW/6.61COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1442kW/6.61COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1459kW_6_40COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1459400,
      COP_nominal =         6.40,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.17,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.05047,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.15,
      TConLvgMax =          273.15 + 37.17,
      capFunT =             {-1.194034E+00,2.466392E-01,-1.770803E-02,1.203228E-01,-2.570051E-03,8.497187E-04},
      EIRFunT =             {-6.559788E-02,4.189764E-02,-9.367876E-03,4.551296E-02,-5.411967E-04,1.453585E-03},
      EIRFunPLR =           {-1.614787E-01,6.417258E-02,1.317124E-05,-2.149029E+00,4.405653E+00,-6.621165E-02,0.000000E+00,-1.055839E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1459kW/6.40COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1459kW/6.40COP/VSD,  !- Name
    1459400,                 !- Reference Capacity {W}
    6.40,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.89,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05047,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1459kW/6.40COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1459kW/6.40COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1459kW/6.40COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.17,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1484kW_9_96COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1484000,
      COP_nominal =         9.96,
      PLRMin =              0.24,
      PLRMinUnl =           0.24,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 17.08,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.08,
      TConLvgMax =          273.15 + 35.97,
      capFunT =             {-9.759100E-01,-1.446866E-01,-4.694254E-03,1.963005E-01,-4.543768E-03,8.998114E-03},
      EIRFunT =             {-6.183288E-01,-1.151565E-01,-1.663662E-04,1.539757E-01,-2.390058E-03,2.818373E-03},
      EIRFunPLR =           {2.203029E-01,9.195177E-02,1.943558E-05,-5.815422E+00,9.366237E+00,-9.299721E-02,0.000000E+00,-2.757689E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1484kW/9.96COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1484kW/9.96COP/VSD,  !- Name
    1484000,                 !- Reference Capacity {W}
    9.96,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    17.08,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1484kW/9.96COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1484kW/9.96COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1484kW/9.96COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.24,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.24,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1495kW_7_51COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1494500,
      COP_nominal =         7.51,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.0429,
      mCon_flow_nominal =   1000 * 0.06719,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 29.92,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.69,
      TConLvgMax =          273.15 + 41.38,
      capFunT =             {6.015487E-01,-1.630120E-01,9.951930E-03,7.452875E-02,-1.608224E-03,2.001891E-03},
      EIRFunT =             {1.954138E-01,-1.627980E-01,5.924232E-03,8.194832E-02,-8.723337E-04,7.443855E-04},
      EIRFunPLR =           {6.377828E-01,-3.620643E-02,-1.187858E-04,5.832958E-01,-9.230655E-01,4.307256E-02,0.000000E+00,6.079021E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1495kW/7.51COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1495kW/7.51COP/VSD,  !- Name
    1494500,                 !- Reference Capacity {W}
    7.51,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    29.92,                   !- Reference Leaving Condenser Water Temperature {C}
    0.0429,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.06719,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1495kW/7.51COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1495kW/7.51COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1495kW/7.51COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_WSC_1519kW_7_10COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1519200,
      COP_nominal =         7.10,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.08139,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 31.76,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.71,
      TConLvgMax =          273.15 + 33.53,
      capFunT =             {1.244930E+00,-3.988254E-02,-8.293893E-03,3.053704E-02,-2.899547E-03,9.784227E-03},
      EIRFunT =             {1.087821E+00,-2.763242E-02,-3.692617E-03,-1.419848E-02,6.903140E-05,2.920296E-03},
      EIRFunPLR =           {4.209093E-01,-1.860468E-02,1.580518E-05,8.654910E-01,-6.538795E-01,1.786849E-02,0.000000E+00,3.759658E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay WSC 1519kW/7.10COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay WSC 1519kW/7.10COP/Vanes,  !- Name
    1519200,                 !- Reference Capacity {W}
    7.10,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    31.76,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.08139,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay WSC 1519kW/7.10COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 1519kW/7.10COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 1519kW/7.10COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1558kW_5_81COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1557800,
      COP_nominal =         5.81,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.61,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 20.93,
      TConLvgMax =          273.15 + 32.69,
      capFunT =             {1.062937E+00,1.795402E-02,-1.393291E-03,-9.669825E-04,-2.580121E-04,7.734796E-04},
      EIRFunT =             {1.228621E+00,-2.576180E-02,5.933105E-04,-2.005035E-02,6.691169E-04,-5.915039E-04},
      EIRFunPLR =           {3.269754E-01,-2.384434E-02,1.204600E-06,3.858219E-01,1.457104E-01,2.369999E-02,0.000000E+00,1.441457E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1558kW/5.81COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1558kW/5.81COP/VSD,  !- Name
    1557800,                 !- Reference Capacity {W}
    5.81,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.61,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1558kW/5.81COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1558kW/5.81COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1558kW/5.81COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1586kW_5_53COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1586000,
      COP_nominal =         5.53,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03388,
      mCon_flow_nominal =   1000 * 0.04669,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 36.26,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 23.36,
      TConLvgMax =          273.15 + 36.72,
      capFunT =             {1.132174E+00,8.236001E-04,-8.207587E-04,2.967657E-03,-3.898313E-04,1.015830E-03},
      EIRFunT =             {1.223690E+00,-3.668987E-02,4.038915E-04,-1.595573E-02,5.080640E-04,-7.276256E-05},
      EIRFunPLR =           {3.381660E-01,-2.323866E-02,-7.810564E-06,1.017389E+00,-8.328919E-01,2.371783E-02,0.000000E+00,4.701559E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1586kW/5.53COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1586kW/5.53COP/VSD,  !- Name
    1586000,                 !- Reference Capacity {W}
    5.53,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    36.26,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03388,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04669,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1586kW/5.53COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1586kW/5.53COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1586kW/5.53COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_1635kW_7_47COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1635200,
      COP_nominal =         7.47,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04416,
      mCon_flow_nominal =   1000 * 0.06624,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 19.47,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.47,
      TConLvgMax =          273.15 + 34.79,
      capFunT =             {8.307757E-01,-2.169411E-02,-3.184578E-03,2.945840E-02,-1.412831E-03,3.405965E-03},
      EIRFunT =             {1.029659E+00,-6.966329E-02,2.674887E-03,9.677160E-04,5.197288E-04,1.456235E-04},
      EIRFunPLR =           {-6.247932E-02,1.538879E-02,4.295421E-05,6.945495E-01,2.544881E-01,-1.740972E-02,0.000000E+00,1.367965E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 1635kW/7.47COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 1635kW/7.47COP/Vanes,  !- Name
    1635200,                 !- Reference Capacity {W}
    7.47,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    19.47,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04416,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06624,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 1635kW/7.47COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1635kW/7.47COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1635kW/7.47COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1635kW_6_36COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1635200,
      COP_nominal =         6.36,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03432,
      mCon_flow_nominal =   1000 * 0.05035,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 35.66,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 20.44,
      TConLvgMax =          273.15 + 36.54,
      capFunT =             {3.092875E-01,-3.293511E-02,-4.782933E-03,6.860171E-02,-2.017588E-03,4.670722E-03},
      EIRFunT =             {6.499856E-01,-6.235681E-03,-2.219743E-04,8.417414E-03,2.314691E-04,-5.679479E-04},
      EIRFunPLR =           {4.206254E-01,-1.310337E-03,8.796454E-05,6.600709E-02,4.642310E-01,-3.720394E-03,0.000000E+00,1.189466E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes,  !- Name
    1635200,                 !- Reference Capacity {W}
    6.36,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    35.66,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03432,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05035,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1656kW_8_24COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1656300,
      COP_nominal =         8.24,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.04322,
      mCon_flow_nominal =   1000 * 0.06296,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 19.83,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 18.63,
      TConLvgMax =          273.15 + 31.21,
      capFunT =             {3.653257E-01,-6.139152E-02,-2.815890E-03,7.447010E-02,-2.488202E-03,5.049502E-03},
      EIRFunT =             {2.129183E-01,-9.725092E-02,-2.082833E-03,8.782361E-02,-1.867589E-03,3.572892E-03},
      EIRFunPLR =           {1.682264E-01,5.313899E-02,1.193363E-04,-2.621319E+00,4.728237E+00,-5.785047E-02,0.000000E+00,-1.229602E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1656kW/8.24COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1656kW/8.24COP/VSD,  !- Name
    1656300,                 !- Reference Capacity {W}
    8.24,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    19.83,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04322,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06296,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1656kW/8.24COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1656kW/8.24COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1656kW/8.24COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1663kW_9_34COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1663300,
      COP_nominal =         9.34,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.04139,
      mCon_flow_nominal =   1000 * 0.0776,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 18.45,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.45,
      TConLvgMax =          273.15 + 34.43,
      capFunT =             {6.972683E-01,-9.692349E-02,4.846738E-03,5.523481E-02,-1.995272E-03,3.533436E-03},
      EIRFunT =             {9.477120E-01,-3.913396E-02,2.408597E-03,6.703909E-03,5.744537E-04,-1.084620E-03},
      EIRFunPLR =           {3.131373E-01,-3.438844E-03,-2.715303E-06,1.918294E-01,7.024552E-01,3.301543E-03,0.000000E+00,-2.040731E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1663kW/9.34COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1663kW/9.34COP/Vanes,  !- Name
    1663300,                 !- Reference Capacity {W}
    9.34,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    18.45,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04139,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0776,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1663kW/9.34COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1663kW/9.34COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1663kW/9.34COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XL_1674kW_7_89COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1673900,
      COP_nominal =         7.89,
      PLRMin =              0.32,
      PLRMinUnl =           0.32,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 17.74,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.74,
      TConLvgMax =          273.15 + 34.74,
      capFunT =             {-1.604710E-01,-5.170996E-02,-1.502523E-03,1.078170E-01,-2.402469E-03,3.063152E-03},
      EIRFunT =             {1.038212E+00,-5.515980E-02,3.732790E-03,2.569418E-03,5.139774E-04,-7.883225E-04},
      EIRFunPLR =           {6.276299E-01,-2.633919E-02,5.269229E-05,1.008569E+00,-1.063131E+00,2.353572E-02,0.000000E+00,4.628347E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes,  !- Name
    1673900,                 !- Reference Capacity {W}
    7.89,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    17.74,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1674kW/7.89COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.32,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.32,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_1681kW_6_59COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1680900,
      COP_nominal =         6.59,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04366,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.90,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 27.96,
      TConLvgMax =          273.15 + 34.43,
      capFunT =             {6.849319E-01,-9.745913E-02,-6.516486E-03,4.595970E-02,-1.596854E-03,7.102706E-03},
      EIRFunT =             {5.325528E-01,2.791268E-02,1.983583E-03,-2.742380E-03,7.801907E-04,-2.694731E-03},
      EIRFunPLR =           {-1.598454E+00,9.989791E-02,-1.680617E-04,1.430978E+00,5.318671E-01,-8.914051E-02,0.000000E+00,4.647834E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 1681kW/6.59COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 1681kW/6.59COP/Vanes,  !- Name
    1680900,                 !- Reference Capacity {W}
    6.59,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.90,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04366,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 1681kW/6.59COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1681kW/6.59COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1681kW/6.59COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1723kW_8_32COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1723100,
      COP_nominal =         8.32,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04757,
      mCon_flow_nominal =   1000 * 0.06934,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 19.44,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 18.07,
      TConLvgMax =          273.15 + 31.40,
      capFunT =             {1.239005E-01,-7.123944E-02,-2.643936E-03,9.396468E-02,-2.643737E-03,4.923920E-03},
      EIRFunT =             {-1.372893E-01,-1.137042E-01,-3.395214E-03,1.210097E-01,-2.615543E-03,4.943923E-03},
      EIRFunPLR =           {1.363743E+00,-2.534882E-02,7.213176E-05,-3.644022E+00,5.935760E+00,2.202104E-02,0.000000E+00,-2.617944E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1723kW/8.32COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1723kW/8.32COP/VSD,  !- Name
    1723100,                 !- Reference Capacity {W}
    8.32,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    19.44,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04757,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06934,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1723kW/8.32COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1723kW/8.32COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1723kW/8.32COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1727kW_9_04COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1726600,
      COP_nominal =         9.04,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03912,
      mCon_flow_nominal =   1000 * 0.07192,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConLvg_nominal =     273.15 + 19.16,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.94,
      TConLvgMax =          273.15 + 35.13,
      capFunT =             {2.574689E-01,2.272600E-03,-5.815624E-03,6.540193E-02,-1.958828E-03,3.701057E-03},
      EIRFunT =             {1.247058E+00,-1.353289E-02,-1.160647E-03,-2.086541E-02,9.395685E-04,-2.989847E-05},
      EIRFunPLR =           {1.552467E-02,1.482533E-02,-2.165341E-05,9.371381E-01,-5.717707E-01,-1.368813E-02,0.000000E+00,6.047782E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes,  !- Name
    1726600,                 !- Reference Capacity {W}
    9.04,                    !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    19.16,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03912,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07192,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_WSC_1751kW_6_73COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1751300,
      COP_nominal =         6.73,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.04145,
      mCon_flow_nominal =   1000 * 0.09337,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 31.82,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.25,
      TConLvgMax =          273.15 + 32.66,
      capFunT =             {6.997155E-01,1.013018E-01,-5.069597E-03,1.512092E-02,-9.198614E-04,1.134806E-03},
      EIRFunT =             {9.968396E-01,2.738711E-02,-1.295424E-03,-2.546976E-02,9.706321E-04,-9.771396E-04},
      EIRFunPLR =           {-4.199061E-01,3.348162E-02,-3.463872E-06,1.370150E+00,-1.116699E+00,-3.393707E-02,0.000000E+00,1.177655E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay WSC 1751kW/6.73COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay WSC 1751kW/6.73COP/Vanes,  !- Name
    1751300,                 !- Reference Capacity {W}
    6.73,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    31.82,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04145,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay WSC 1751kW/6.73COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 1751kW/6.73COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay WSC 1751kW/6.73COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_1758kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.96,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.23,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 20.13,
      TConLvgMax =          273.15 + 32.40,
      capFunT =             {1.152910E+00,-3.989989E-03,-3.188662E-03,-1.713324E-02,1.013638E-04,2.380003E-03},
      EIRFunT =             {5.175819E-02,-9.767577E-02,4.582364E-03,6.527440E-02,-7.594482E-04,1.621435E-04},
      EIRFunPLR =           {-3.445966E+00,3.643598E-01,-1.697759E-04,-2.909905E+00,6.045776E+00,-3.553254E-01,0.000000E+00,1.192526E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 1758kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 1758kW/5.96COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.23,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 1758kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1758kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1758kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1758kW_5_76COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.76,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.27,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.51,
      TConLvgMin =          273.15 + 21.27,
      TConLvgMax =          273.15 + 32.81,
      capFunT =             {1.960842E-01,1.462778E-01,-4.568082E-03,3.185311E-02,-6.290125E-04,-1.279459E-03},
      EIRFunT =             {9.622331E-01,8.325124E-02,-2.403189E-03,-3.668907E-02,1.323874E-03,-2.828319E-03},
      EIRFunPLR =           {4.914420E-01,-3.736264E-02,-1.708310E-04,7.127945E-01,-1.838011E-01,4.633977E-02,0.000000E+00,-1.370201E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1758kW/5.76COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1758kW/5.76COP/VSD,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.76,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.27,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1758kW/5.76COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/5.76COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/5.76COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1758kW_6_26COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.26,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.16,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.18,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 21.48,
      TConLvgMax =          273.15 + 33.76,
      capFunT =             {4.841919E-01,-2.437152E-02,3.244522E-03,5.590357E-02,-1.302819E-03,9.257097E-04},
      EIRFunT =             {1.729452E-01,9.227136E-02,-5.580943E-03,1.946191E-02,3.155080E-05,-7.904242E-04},
      EIRFunPLR =           {9.471258E-01,-4.669457E-02,-4.461248E-04,5.587776E-02,6.578054E-01,7.103286E-02,0.000000E+00,-9.855688E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1758kW/6.26COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1758kW/6.26COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.26,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.18,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1758kW/6.26COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/6.26COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/6.26COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.16,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1758kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.96,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.23,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 21.29,
      TConLvgMax =          273.15 + 33.53,
      capFunT =             {8.075668E-01,5.287917E-02,-4.493793E-04,7.036068E-03,-3.536822E-04,3.731438E-04},
      EIRFunT =             {2.593808E-01,-1.873181E-03,-4.808688E-04,3.822020E-02,-3.813018E-04,-2.995903E-04},
      EIRFunPLR =           {1.303414E-01,1.618347E-02,-7.157278E-05,-1.337481E-01,1.186910E+00,-1.240299E-02,0.000000E+00,-2.328976E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1758kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1758kW/5.96COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.23,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1758kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHE_1758kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.96,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.63,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 28.68,
      TConLvgMax =          273.15 + 40.15,
      capFunT =             {-3.784203E-01,-8.333229E-02,-8.509675E-03,1.031937E-01,-2.432261E-03,7.065530E-03},
      EIRFunT =             {1.583438E+00,-3.412919E-03,4.476231E-03,-5.243024E-02,1.295102E-03,-2.210725E-03},
      EIRFunPLR =           {1.466664E+00,-4.222011E-02,-1.153513E-04,-7.738226E-02,-9.896333E-01,5.014539E-02,0.000000E+00,4.671251E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHE 1758kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHE 1758kW/5.96COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.63,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHE 1758kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1758kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHE 1758kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1758kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.28,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.60,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.46,
      TConLvgMax =          273.15 + 39.72,
      capFunT =             {5.062633E-01,-9.373882E-03,-2.822764E-03,4.202164E-02,-1.092132E-03,2.074549E-03},
      EIRFunT =             {5.699849E-01,-9.813327E-03,4.223116E-04,4.842283E-03,4.078201E-04,-7.615896E-04},
      EIRFunPLR =           {2.911331E-01,-4.317969E-03,1.448369E-05,6.226793E-01,7.992053E-02,3.393326E-03,0.000000E+00,1.919540E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1758kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1758kW/6.28COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.60,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1758kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1758kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1758kW_5_86COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.86,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06303,
      mCon_flow_nominal =   1000 * 0.07337,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.15,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 17.86,
      TConLvgMax =          273.15 + 31.43,
      capFunT =             {9.528317E-02,-4.119086E-02,-3.854298E-03,7.698517E-02,-1.945011E-03,4.285126E-03},
      EIRFunT =             {-6.333861E-02,-5.533069E-02,-4.591740E-03,7.468402E-02,-1.455300E-03,3.506040E-03},
      EIRFunPLR =           {1.251509E+00,-9.433150E-02,-2.849753E-05,8.544238E-01,-1.491994E+00,9.568956E-02,0.000000E+00,3.698862E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1758kW/5.86COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1758kW/5.86COP/VSD,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.86,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.15,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06303,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1758kW/5.86COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1758kW/5.86COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1758kW/5.86COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_1758kW_6_46COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.46,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.14,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 20.10,
      TConLvgMax =          273.15 + 32.22,
      capFunT =             {1.155538E+00,-6.017270E-03,-3.052085E-03,-1.615198E-02,1.178682E-04,2.213641E-03},
      EIRFunT =             {-2.601408E-01,2.870346E-02,2.635595E-04,4.992457E-02,-1.859076E-04,-1.832446E-03},
      EIRFunPLR =           {-1.842588E-01,5.105821E-02,6.142934E-05,6.478691E-01,-4.242816E-01,-5.442456E-02,0.000000E+00,1.005374E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 1758kW/6.46COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 1758kW/6.46COP/VSD,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.46,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.14,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 1758kW/6.46COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1758kW/6.46COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1758kW/6.46COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_1758kW_6_87COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.87,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.08,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 20.44,
      TConLvgMax =          273.15 + 32.98,
      capFunT =             {7.950124E-01,3.170632E-02,-5.547610E-04,4.268492E-03,-1.289046E-04,4.509069E-04},
      EIRFunT =             {6.428117E-01,1.299499E-02,5.872739E-04,-5.532320E-03,6.809308E-04,-1.480167E-03},
      EIRFunPLR =           {5.682807E-01,-3.888781E-02,6.619097E-06,1.715735E+00,-1.791541E+00,3.851853E-02,0.000000E+00,5.124705E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 1758kW/6.87COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 1758kW/6.87COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.87,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.08,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 1758kW/6.87COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1758kW/6.87COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1758kW/6.87COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1776kW_8_00COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1775900,
      COP_nominal =         8.00,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04757,
      mCon_flow_nominal =   1000 * 0.07003,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 19.60,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 18.69,
      TConLvgMax =          273.15 + 30.73,
      capFunT =             {-1.221213E-01,-6.119865E-02,-1.798410E-03,1.162623E-01,-3.162366E-03,4.088809E-03},
      EIRFunT =             {7.400829E-01,-2.067083E-02,6.695036E-04,1.727139E-02,2.554481E-04,-7.023159E-04},
      EIRFunPLR =           {8.623059E-01,-3.289272E-02,6.345837E-05,1.416109E-01,2.335827E-01,3.016537E-02,0.000000E+00,-2.083488E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes,  !- Name
    1775900,                 !- Reference Capacity {W}
    8.00,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    19.60,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04757,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07003,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XL_1779kW_6_18COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1779400,
      COP_nominal =         6.18,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06303,
      mCon_flow_nominal =   1000 * 0.08858,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.69,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.83,
      TConLvgMax =          273.15 + 32.12,
      capFunT =             {-7.421879E-02,-6.864609E-02,-6.656797E-03,9.778610E-02,-2.680195E-03,6.765638E-03},
      EIRFunT =             {5.396428E-01,-3.183208E-02,1.041725E-03,2.112772E-02,4.504330E-05,-4.947764E-04},
      EIRFunPLR =           {7.137642E-01,-3.096191E-02,1.459047E-04,8.907204E-01,-1.051301E+00,2.348095E-02,0.000000E+00,5.406677E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes,  !- Name
    1779400,                 !- Reference Capacity {W}
    6.18,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.69,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06303,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.08858,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_1779kW_6_18COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1779400,
      COP_nominal =         6.18,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.04454,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 33.51,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 27.96,
      TConLvgMax =          273.15 + 34.47,
      capFunT =             {-1.379667E-01,-8.817299E-02,-1.551247E-03,9.297586E-02,-1.943005E-03,4.050538E-03},
      EIRFunT =             {3.679272E-01,3.649996E-03,-1.333659E-03,6.605569E-03,4.699578E-04,-5.527094E-04},
      EIRFunPLR =           {6.454991E-03,1.094255E-02,5.090580E-05,8.866733E-01,-4.314429E-01,-1.400320E-02,0.000000E+00,5.835670E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 1779kW/6.18COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 1779kW/6.18COP/Vanes,  !- Name
    1779400,                 !- Reference Capacity {W}
    6.18,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    33.51,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04454,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 1779kW/6.18COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1779kW/6.18COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 1779kW/6.18COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1794kW_8_11COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1793500,
      COP_nominal =         8.11,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.08,
      mEva_flow_nominal =   1000 * 0.05148,
      mCon_flow_nominal =   1000 * 0.09653,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 28.88,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.71,
      TConLvgMax =          273.15 + 34.34,
      capFunT =             {1.475615E+00,-2.480005E-01,1.353388E-02,5.216264E-02,-2.330109E-03,5.131852E-03},
      EIRFunT =             {1.190864E+00,3.400270E-01,-8.717000E-03,-1.107704E-01,3.433891E-03,-8.538300E-03},
      EIRFunPLR =           {-9.081317E-02,1.524614E-02,8.256304E-04,-6.921348E-01,4.110008E+00,-6.003188E-02,0.000000E+00,-1.751625E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1794kW/8.11COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1794kW/8.11COP/Vanes,  !- Name
    1793500,                 !- Reference Capacity {W}
    8.11,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    28.88,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05148,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09653,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1794kW/8.11COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1794kW/8.11COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1794kW/8.11COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
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
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1794kW_7_90COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1793500,
      COP_nominal =         7.90,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.05148,
      mCon_flow_nominal =   1000 * 0.09653,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 28.90,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.43,
      TConLvgMax =          273.15 + 35.71,
      capFunT =             {7.431766E-01,-1.738759E-01,7.863010E-03,6.780689E-02,-1.636950E-03,3.409649E-03},
      EIRFunT =             {3.622079E-01,-1.249125E-01,5.333823E-03,5.641261E-02,-3.290614E-04,8.180145E-06},
      EIRFunPLR =           {3.828090E-01,-1.598908E-02,-1.273038E-04,5.991790E-01,-5.063099E-01,2.273951E-02,0.000000E+00,4.390985E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1794kW/7.90COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1794kW/7.90COP/VSD,  !- Name
    1793500,                 !- Reference Capacity {W}
    7.90,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    28.90,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05148,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09653,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1794kW/7.90COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1794kW/7.90COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1794kW/7.90COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XL_1797kW_5_69COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1797000,
      COP_nominal =         5.69,
      PLRMin =              0.39,
      PLRMinUnl =           0.39,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.07737,
      mCon_flow_nominal =   1000 * 0.09672,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.67,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 26.59,
      TConLvgMax =          273.15 + 34.91,
      capFunT =             {9.173209E-01,4.990036E-02,-1.196031E-03,-2.024380E-03,-3.141698E-05,-3.752508E-04},
      EIRFunT =             {1.079738E+00,-4.447776E-02,1.617276E-03,8.485662E-04,8.268362E-05,5.543283E-05},
      EIRFunPLR =           {5.147565E+00,-1.604653E-01,2.139293E-05,-3.215408E+00,-1.636618E+00,1.592219E-01,0.000000E+00,7.224656E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes,  !- Name
    1797000,                 !- Reference Capacity {W}
    5.69,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.67,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07737,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09672,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.39,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.39,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_1801kW_6_34COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1800500,
      COP_nominal =         6.34,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05161,
      mCon_flow_nominal =   1000 * 0.06385,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 31.70,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 19.63,
      TConLvgMax =          273.15 + 32.95,
      capFunT =             {3.277256E-01,-9.423458E-02,-1.714249E-03,7.496846E-02,-1.987466E-03,4.807394E-03},
      EIRFunT =             {6.993760E-01,3.436644E-03,1.120695E-03,-3.794674E-03,7.200808E-04,-1.623357E-03},
      EIRFunPLR =           {-3.986781E-03,2.064845E-02,-1.459614E-05,-5.111204E-01,2.257468E+00,-1.990453E-02,0.000000E+00,-7.517775E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 1801kW/6.34COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 1801kW/6.34COP/VSD,  !- Name
    1800500,                 !- Reference Capacity {W}
    6.34,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    31.70,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05161,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06385,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 1801kW/6.34COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1801kW/6.34COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 1801kW/6.34COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1867kW_10_09COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1867300,
      COP_nominal =         10.09,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConLvg_nominal =     273.15 + 18.18,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.96,
      TConLvgMax =          273.15 + 39.35,
      capFunT =             {-8.621766E-02,-4.282771E-02,-4.467391E-03,9.890042E-02,-2.768144E-03,5.728215E-03},
      EIRFunT =             {6.584483E-01,1.696214E-02,-3.465522E-03,2.078998E-02,2.909474E-04,-2.222756E-04},
      EIRFunPLR =           {-3.108659E-01,5.639190E-02,-6.487474E-05,-9.450752E-01,2.690004E+00,-5.309347E-02,0.000000E+00,-4.748500E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1867kW/10.09COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1867kW/10.09COP/Vanes,  !- Name
    1867300,                 !- Reference Capacity {W}
    10.09,                   !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    18.18,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1867kW/10.09COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1867kW/10.09COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1867kW/10.09COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XL_1871kW_6_49COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1870800,
      COP_nominal =         6.49,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06303,
      mCon_flow_nominal =   1000 * 0.0877,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 32.00,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.92,
      TConLvgMax =          273.15 + 35.06,
      capFunT =             {-7.422008E-01,-5.893189E-02,-6.359815E-03,1.450953E-01,-3.416848E-03,5.905773E-03},
      EIRFunT =             {1.182368E+00,-6.852914E-02,2.718010E-03,-1.693531E-02,6.861400E-04,4.136164E-05},
      EIRFunPLR =           {1.085769E+00,-5.971095E-02,1.041798E-04,7.182300E-01,-5.729312E-01,5.367072E-02,0.000000E+00,-1.472327E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes,  !- Name
    1870800,                 !- Reference Capacity {W}
    6.49,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    32.00,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06303,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0877,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1881kW_6_77COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1881400,
      COP_nominal =         6.77,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 29.35,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.80,
      TConLvgMax =          273.15 + 35.02,
      capFunT =             {2.510830E-01,-3.997687E-02,-3.627911E-03,6.819530E-02,-2.135260E-03,5.245082E-03},
      EIRFunT =             {5.450343E-01,-3.893169E-02,9.377632E-04,2.314284E-02,-1.134638E-05,7.362152E-05},
      EIRFunPLR =           {4.949889E-02,2.267854E-02,-2.003269E-05,-9.059476E-01,3.032884E+00,-2.155668E-02,0.000000E+00,-1.190898E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 1881kW/6.77COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1881kW/6.77COP/VSD,  !- Name
    1881400,                 !- Reference Capacity {W}
    6.77,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.35,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1881kW/6.77COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1881kW/6.77COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1881kW/6.77COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_1881kW_6_53COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1881400,
      COP_nominal =         6.53,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04397,
      mCon_flow_nominal =   1000 * 0.1041,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 31.65,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 15.00,
      TConLvgMax =          273.15 + 32.45,
      capFunT =             {8.031671E-01,3.618657E-02,-1.027472E-03,1.237132E-02,-7.469842E-04,1.123058E-03},
      EIRFunT =             {4.262865E-01,4.727402E-02,-1.347198E-03,4.334960E-03,5.282605E-04,-1.449676E-03},
      EIRFunPLR =           {2.470999E-01,-4.530708E-03,2.522038E-05,-5.464802E-01,2.572647E+00,3.398388E-03,0.000000E+00,-1.261128E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 1881kW/6.53COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 1881kW/6.53COP/Vanes,  !- Name
    1881400,                 !- Reference Capacity {W}
    6.53,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    31.65,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04397,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.1041,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 1881kW/6.53COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 1881kW/6.53COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 1881kW/6.53COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_1895kW_6_42COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1895400,
      COP_nominal =         6.42,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.1,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 29.66,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.93,
      TConLvgMax =          273.15 + 40.14,
      capFunT =             {4.518352E-01,-1.535612E-01,1.760231E-03,8.123118E-02,-2.460493E-03,6.371948E-03},
      EIRFunT =             {1.851189E-01,-3.198165E-02,-8.437565E-04,4.384625E-02,-4.446880E-04,8.645981E-04},
      EIRFunPLR =           {4.912394E-02,1.922190E-02,1.458006E-04,-1.286997E-01,1.371824E+00,-2.769626E-02,0.000000E+00,-1.782073E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 1895kW/6.42COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 1895kW/6.42COP/Vanes,  !- Name
    1895400,                 !- Reference Capacity {W}
    6.42,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.66,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 1895kW/6.42COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1895kW/6.42COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1895kW/6.42COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.1,                     !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_1934kW_7_55COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1934100,
      COP_nominal =         7.55,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.05552,
      mCon_flow_nominal =   1000 * 0.08675,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 19.93,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.55,
      TConLvgMax =          273.15 + 35.11,
      capFunT =             {-8.034452E-01,5.620880E-02,-1.066333E-03,1.377705E-01,-3.123388E-03,1.042684E-03},
      EIRFunT =             {1.464148E+00,-1.335550E-01,4.793466E-03,-2.069042E-02,6.523211E-04,1.245111E-03},
      EIRFunPLR =           {7.339218E-01,-3.184317E-02,-9.387398E-05,-2.274806E-01,1.677164E+00,3.688705E-02,0.000000E+00,-1.250228E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 1934kW/7.55COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 1934kW/7.55COP/Vanes,  !- Name
    1934100,                 !- Reference Capacity {W}
    7.55,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    19.93,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05552,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.08675,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 1934kW/7.55COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 1934kW/7.55COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 1934kW/7.55COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PEH_1934kW_6_01COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1934100,
      COP_nominal =         6.01,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.05552,
      mCon_flow_nominal =   1000 * 0.07981,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.54,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.00,
      TConLvgMax =          273.15 + 36.60,
      capFunT =             {-4.043899E-01,-5.695254E-02,-1.353511E-03,1.215555E-01,-2.814037E-03,4.161831E-03},
      EIRFunT =             {1.191090E-01,7.702949E-04,-2.852916E-03,4.290826E-02,-4.014538E-04,8.913432E-04},
      EIRFunPLR =           {1.000427E+00,-3.176111E-02,-2.412562E-04,4.886225E-01,-2.020669E+00,4.495646E-02,0.000000E+00,1.357430E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PEH 1934kW/6.01COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PEH 1934kW/6.01COP/Vanes,  !- Name
    1934100,                 !- Reference Capacity {W}
    6.01,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.54,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05552,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07981,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PEH 1934kW/6.01COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1934kW/6.01COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PEH 1934kW/6.01COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_McQuay_WDC_1973kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1972800,
      COP_nominal =         6.28,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.04145,
      mCon_flow_nominal =   1000 * 0.09337,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 32.53,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.36,
      TConLvgMax =          273.15 + 32.81,
      capFunT =             {1.327385E+00,5.589128E-02,-6.418354E-03,-2.827763E-02,-2.655572E-04,2.996574E-03},
      EIRFunT =             {1.179827E+00,-5.349290E-02,-2.095113E-03,-1.285812E-02,2.267511E-04,2.197542E-03},
      EIRFunPLR =           {-9.986603E-01,7.542346E-02,-5.753431E-05,6.665711E-02,2.154745E+00,-7.250027E-02,0.000000E+00,-2.590669E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay WDC 1973kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay WDC 1973kW/6.28COP/Vanes,  !- Name
    1972800,                 !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    32.53,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04145,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay WDC 1973kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay WDC 1973kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay WDC 1973kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_1997kW_7_24COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1997400,
      COP_nominal =         7.24,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.04397,
      mCon_flow_nominal =   1000 * 0.1041,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 31.89,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 19.16,
      TConLvgMax =          273.15 + 32.70,
      capFunT =             {1.039493E+00,1.593009E-01,-3.989073E-03,-3.812180E-02,2.881779E-04,-7.520087E-04},
      EIRFunT =             {1.550813E-01,1.022114E-01,-6.511170E-04,-1.241272E-02,1.514358E-03,-4.090377E-03},
      EIRFunPLR =           {1.838759E-01,-1.009515E-02,1.677624E-04,9.181489E-01,-2.434151E-02,1.727052E-03,0.000000E+00,2.527075E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 1997kW/7.24COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 1997kW/7.24COP/Vanes,  !- Name
    1997400,                 !- Reference Capacity {W}
    7.24,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    31.89,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04397,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.1041,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 1997kW/7.24COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 1997kW/7.24COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 1997kW/7.24COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PFH_2043kW_8_44COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2043100,
      COP_nominal =         8.44,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.04757,
      mCon_flow_nominal =   1000 * 0.06814,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 20.80,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 20.80,
      TConLvgMax =          273.15 + 32.72,
      capFunT =             {7.565419E-01,1.690707E-02,-3.988252E-03,2.008625E-02,-1.439363E-03,3.931271E-03},
      EIRFunT =             {6.806067E-01,5.701621E-03,-1.329020E-03,1.210419E-02,2.563048E-04,-2.528032E-04},
      EIRFunPLR =           {-7.300240E-01,6.016914E-02,2.516862E-05,1.606362E-01,1.803623E+00,-6.158982E-02,0.000000E+00,-2.149832E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PFH 2043kW/8.44COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PFH 2043kW/8.44COP/Vanes,  !- Name
    2043100,                 !- Reference Capacity {W}
    8.44,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    20.80,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04757,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06814,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PFH 2043kW/8.44COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 2043kW/8.44COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 2043kW/8.44COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_2043kW_9_08COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2043100,
      COP_nominal =         9.08,
      PLRMin =              0.28,
      PLRMinUnl =           0.28,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 23.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 23.06,
      TConLvgMax =          273.15 + 34.90,
      capFunT =             {-2.215335E+00,-3.294601E-02,-5.300740E-03,2.341598E-01,-4.558661E-03,4.631243E-03},
      EIRFunT =             {1.008753E+00,3.282653E-02,3.719189E-03,-2.508242E-02,1.367676E-03,-3.739705E-03},
      EIRFunPLR =           {3.696812E-01,3.068332E-02,1.965912E-05,-1.915197E+00,3.980757E+00,-3.185207E-02,0.000000E+00,-1.418416E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 2043kW/9.08COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 2043kW/9.08COP/Vanes,  !- Name
    2043100,                 !- Reference Capacity {W}
    9.08,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    23.11,                   !- Reference Leaving Condenser Water Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 2043kW/9.08COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2043kW/9.08COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2043kW/9.08COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.28,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.28,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XL_2057kW_6_05COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2057200,
      COP_nominal =         6.05,
      PLRMin =              0.28,
      PLRMinUnl =           0.28,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.08322,
      mCon_flow_nominal =   1000 * 0.09722,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConLvg_nominal =     273.15 + 29.79,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.89,
      TConLvgMax =          273.15 + 35.37,
      capFunT =             {6.448091E-01,-3.315001E-02,-3.168485E-03,3.196459E-02,-1.138880E-03,3.799700E-03},
      EIRFunT =             {7.341312E-01,-7.592418E-02,-2.065951E-03,3.153945E-02,-8.888217E-04,3.650961E-03},
      EIRFunPLR =           {1.353291E-01,-5.973382E-03,-2.152787E-05,1.844856E+00,-2.868168E+00,7.003543E-03,0.000000E+00,1.875512E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes,  !- Name
    2057200,                 !- Reference Capacity {W}
    6.05,                    !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    29.79,                   !- Reference Leaving Condenser Water Temperature {C}
    0.08322,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09722,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.28,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.28,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_2110kW_7_15COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2110000,
      COP_nominal =         7.15,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.06057,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 29.97,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.99,
      TConLvgMax =          273.15 + 34.89,
      capFunT =             {6.132568E-02,-1.142230E-02,1.660419E-03,8.345415E-02,-2.159087E-03,1.699787E-03},
      EIRFunT =             {6.140372E-01,-4.277763E-02,9.446169E-04,1.580154E-02,1.226130E-04,3.616708E-04},
      EIRFunPLR =           {3.834325E-01,-1.806511E-03,5.390925E-05,1.510060E-02,7.165451E-01,-1.195918E-03,0.000000E+00,-7.564269E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 2110kW/7.15COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 2110kW/7.15COP/Vanes,  !- Name
    2110000,                 !- Reference Capacity {W}
    7.15,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    29.97,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06057,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 2110kW/7.15COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 2110kW/7.15COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 2110kW/7.15COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PFH_2124kW_6_03COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2124000,
      COP_nominal =         6.03,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05552,
      mCon_flow_nominal =   1000 * 0.07981,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConLvg_nominal =     273.15 + 31.31,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.28,
      TConLvgMax =          273.15 + 36.13,
      capFunT =             {8.466662E-01,-3.809647E-02,4.003930E-04,2.913659E-02,-1.138034E-03,2.405293E-03},
      EIRFunT =             {1.198331E+00,-5.731652E-02,-4.950792E-03,-1.013222E-02,-1.112759E-04,4.138878E-03},
      EIRFunPLR =           {-1.353862E+00,9.444334E-02,-1.467992E-05,1.291373E+00,-2.276361E-01,-9.395594E-02,0.000000E+00,1.285196E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PFH 2124kW/6.03COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PFH 2124kW/6.03COP/Vanes,  !- Name
    2124000,                 !- Reference Capacity {W}
    6.03,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    31.31,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05552,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07981,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PFH 2124kW/6.03COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 2124kW/6.03COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 2124kW/6.03COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_2159kW_6_85COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2159200,
      COP_nominal =         6.85,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.32,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.13,
      TConLvgMax =          273.15 + 34.75,
      capFunT =             {-5.164056E-02,-7.384855E-02,-1.036241E-02,1.201446E-01,-3.881099E-03,9.873049E-03},
      EIRFunT =             {1.013059E+00,2.176325E-03,-4.682395E-04,-1.887683E-02,7.444727E-04,-6.685547E-04},
      EIRFunPLR =           {2.315688E-02,2.746250E-02,-2.345600E-05,-4.728932E-01,1.778530E+00,-2.621741E-02,0.000000E+00,-3.448533E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 2159kW/6.85COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 2159kW/6.85COP/Vanes,  !- Name
    2159200,                 !- Reference Capacity {W}
    6.85,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.32,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 2159kW/6.85COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 2159kW/6.85COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 2159kW/6.85COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_2184kW_6_78COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2183800,
      COP_nominal =         6.78,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04883,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConLvg_nominal =     273.15 + 35.55,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 30.67,
      TConLvgMax =          273.15 + 36.06,
      capFunT =             {1.214452E+00,-1.495671E-02,-2.934194E-03,1.568925E-02,-9.780218E-04,2.723254E-03},
      EIRFunT =             {1.286650E+00,3.478277E-02,2.888239E-03,-4.763798E-02,1.463610E-03,-3.194170E-03},
      EIRFunPLR =           {2.473025E+00,-1.277887E-01,-3.279364E-05,-3.156699E-01,-3.527895E-01,1.304080E-01,0.000000E+00,-8.547163E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 2184kW/6.78COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 2184kW/6.78COP/Vanes,  !- Name
    2183800,                 !- Reference Capacity {W}
    6.78,                    !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    35.55,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04883,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 2184kW/6.78COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2184kW/6.78COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2184kW/6.78COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_2201kW_6_69COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2201400,
      COP_nominal =         6.69,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.11,
      TConLvgMax =          273.15 + 34.92,
      capFunT =             {-2.132698E-01,-9.712289E-02,-7.445252E-03,1.333444E-01,-3.971284E-03,9.247854E-03},
      EIRFunT =             {8.761500E-01,2.513467E-02,-8.565300E-04,-1.383243E-02,6.968311E-04,-1.236275E-03},
      EIRFunPLR =           {3.515554E-03,3.070346E-02,-1.198496E-08,-5.568236E-01,1.810053E+00,-3.070120E-02,0.000000E+00,-2.564025E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 2201kW/6.69COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 2201kW/6.69COP/Vanes,  !- Name
    2201400,                 !- Reference Capacity {W}
    6.69,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.44,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 2201kW/6.69COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 2201kW/6.69COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 2201kW/6.69COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_2233kW_9_54COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2233000,
      COP_nominal =         9.54,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.06107,
      mCon_flow_nominal =   1000 * 0.11451,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 17.93,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.93,
      TConLvgMax =          273.15 + 34.11,
      capFunT =             {4.939632E-01,-9.743766E-02,6.782771E-03,7.149216E-02,-2.077461E-03,2.246608E-03},
      EIRFunT =             {7.177745E-01,-9.460212E-04,-1.451469E-03,1.431719E-02,5.149926E-04,-8.367784E-04},
      EIRFunPLR =           {4.637900E-01,-3.344690E-02,2.768776E-04,-2.457480E-03,1.477501E+00,1.903803E-02,0.000000E+00,-7.622945E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YT 2233kW/9.54COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 2233kW/9.54COP/VSD,  !- Name
    2233000,                 !- Reference Capacity {W}
    9.54,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    17.93,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06107,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11451,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 2233kW/9.54COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 2233kW/9.54COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 2233kW/9.54COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YK_2237kW_6_41COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2236600,
      COP_nominal =         6.41,
      PLRMin =              0.13,
      PLRMinUnl =           0.13,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.56,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.30,
      TConLvgMax =          273.15 + 35.03,
      capFunT =             {2.686272E-01,-4.051077E-02,-2.130203E-03,7.674578E-02,-2.282522E-03,4.478325E-03},
      EIRFunT =             {9.801548E-01,2.026687E-02,1.578707E-03,-2.077442E-02,9.180399E-04,-2.105614E-03},
      EIRFunPLR =           {2.013555E-01,1.055744E-02,-2.587525E-05,-3.074339E-01,1.634011E+00,-9.188562E-03,0.000000E+00,-5.458636E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 2237kW/6.41COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 2237kW/6.41COP/Vanes,  !- Name
    2236600,                 !- Reference Capacity {W}
    6.41,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.56,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 2237kW/6.41COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 2237kW/6.41COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 2237kW/6.41COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.13,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.13,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_2275kW_6_32COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2275200,
      COP_nominal =         6.32,
      PLRMin =              0.13,
      PLRMinUnl =           0.13,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.66,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.78,
      TConLvgMax =          273.15 + 35.17,
      capFunT =             {9.227391E-01,-3.381914E-02,4.402874E-04,2.528344E-02,-1.131217E-03,2.844510E-03},
      EIRFunT =             {8.910758E-01,4.115735E-03,-2.403988E-04,-1.277389E-02,6.650664E-04,-8.163142E-04},
      EIRFunPLR =           {2.464807E-01,6.198472E-03,-2.091245E-05,-1.584035E-01,1.396936E+00,-5.134757E-03,0.000000E+00,-4.982764E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 2275kW/6.32COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 2275kW/6.32COP/Vanes,  !- Name
    2275200,                 !- Reference Capacity {W}
    6.32,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.66,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 2275kW/6.32COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 2275kW/6.32COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 2275kW/6.32COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.13,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.13,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_2300kW_8_10COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2299900,
      COP_nominal =         8.10,
      PLRMin =              0.23,
      PLRMinUnl =           0.23,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 19.58,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.58,
      TConLvgMax =          273.15 + 34.79,
      capFunT =             {4.945951E-02,1.763194E-02,-1.707908E-03,8.024411E-02,-2.301455E-03,2.334434E-03},
      EIRFunT =             {6.870347E-01,1.176508E-02,5.473075E-04,1.235577E-02,3.200085E-04,-1.378535E-03},
      EIRFunPLR =           {-8.187804E-01,9.052788E-02,-2.443564E-04,-2.116230E+00,5.680799E+00,-7.780553E-02,0.000000E+00,-1.907348E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 2300kW/8.10COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 2300kW/8.10COP/Vanes,  !- Name
    2299900,                 !- Reference Capacity {W}
    8.10,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    19.58,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 2300kW/8.10COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2300kW/8.10COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2300kW/8.10COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.23,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.23,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_2317kW_6_33COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2317400,
      COP_nominal =         6.33,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 35.10,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.67,
      TConLvgMax =          273.15 + 35.67,
      capFunT =             {6.632457E-01,4.608638E-03,-1.100111E-03,1.651605E-02,-4.753748E-04,1.648311E-03},
      EIRFunT =             {2.905409E-01,-2.093028E-02,9.792522E-04,1.493146E-02,3.511684E-04,-8.356167E-04},
      EIRFunPLR =           {-4.540034E-01,3.433262E-02,4.845589E-05,9.799190E-01,2.028044E-01,-3.705958E-02,0.000000E+00,3.066979E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 2317kW/6.33COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 2317kW/6.33COP/VSD,  !- Name
    2317400,                 !- Reference Capacity {W}
    6.33,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    35.10,                   !- Reference Leaving Condenser Water Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 2317kW/6.33COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2317kW/6.33COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2317kW/6.33COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_2391kW_6_77COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2391300,
      COP_nominal =         6.77,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06858,
      mCon_flow_nominal =   1000 * 0.0846,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 31.65,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 19.72,
      TConLvgMax =          273.15 + 32.63,
      capFunT =             {-1.092340E-01,-7.214951E-02,-1.929403E-03,1.073964E-01,-2.585892E-03,4.163448E-03},
      EIRFunT =             {6.095032E-01,-1.108553E-02,6.938966E-04,1.166583E-02,2.514251E-04,-7.733820E-04},
      EIRFunPLR =           {4.306200E-01,-7.328716E-03,9.930747E-06,9.234623E-01,-1.158929E+00,6.792175E-03,0.000000E+00,8.117517E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes,  !- Name
    2391300,                 !- Reference Capacity {W}
    6.77,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    31.65,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06858,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0846,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19XR_2391kW_6_44COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2391300,
      COP_nominal =         6.44,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06858,
      mCon_flow_nominal =   1000 * 0.0846,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 31.70,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 19.76,
      TConLvgMax =          273.15 + 32.68,
      capFunT =             {-1.105784E-01,-7.215657E-02,-1.924398E-03,1.073110E-01,-2.578512E-03,4.153768E-03},
      EIRFunT =             {6.030335E-01,-1.099862E-02,6.898379E-04,1.213607E-02,2.415707E-04,-7.792847E-04},
      EIRFunPLR =           {1.309393E-01,1.443518E-02,-9.784460E-07,-8.596110E-01,2.724452E+00,-1.436270E-02,0.000000E+00,-9.969677E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19XR 2391kW/6.44COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19XR 2391kW/6.44COP/VSD,  !- Name
    2391300,                 !- Reference Capacity {W}
    6.44,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    31.70,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06858,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0846,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19XR 2391kW/6.44COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 2391kW/6.44COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19XR 2391kW/6.44COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_2412kW_5_58COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2412400,
      COP_nominal =         5.58,
      PLRMin =              0.12,
      PLRMinUnl =           0.12,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 32.10,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.30,
      TConLvgMax =          273.15 + 35.78,
      capFunT =             {6.042244E-01,-5.282819E-03,-1.993748E-04,2.972266E-02,-8.288016E-04,1.587869E-03},
      EIRFunT =             {3.175495E-01,-2.563749E-02,1.177157E-03,3.422467E-02,-2.556973E-04,-1.034934E-04},
      EIRFunPLR =           {-8.659288E-02,4.280342E-02,4.027354E-05,-8.726041E-01,3.432389E+00,-4.514744E-02,0.000000E+00,-1.440179E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 2412kW/5.58COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 2412kW/5.58COP/Vanes,  !- Name
    2412400,                 !- Reference Capacity {W}
    5.58,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    32.10,                   !- Reference Leaving Condenser Water Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 2412kW/5.58COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 2412kW/5.58COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 2412kW/5.58COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.12,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.12,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PFH_2462kW_6_67COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2461600,
      COP_nominal =         6.67,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.07066,
      mCon_flow_nominal =   1000 * 0.10157,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.31,
      TConLvgMax =          273.15 + 31.55,
      capFunT =             {4.142265E-01,1.542602E-02,-7.911049E-03,7.508392E-02,-2.773731E-03,5.837360E-03},
      EIRFunT =             {5.570216E-01,9.193251E-03,-5.145487E-03,6.832209E-03,1.403064E-04,1.590130E-03},
      EIRFunPLR =           {-8.594949E-01,6.566973E-02,1.939985E-05,1.001788E+00,1.280680E-01,-6.652851E-02,0.000000E+00,7.389430E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PFH 2462kW/6.67COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PFH 2462kW/6.67COP/Vanes,  !- Name
    2461600,                 !- Reference Capacity {W}
    6.67,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07066,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.10157,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PFH 2462kW/6.67COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 2462kW/6.67COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 2462kW/6.67COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHG670_44_86_2490kW_6_5COP =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2490036,
      COP_nominal =         6.505,
      PLRMin =              0.087,
      PLRMinUnl =           0.087,
      PLRMax =              1.001,
      mEva_flow_nominal =   1000 * 0.08894,
      mCon_flow_nominal =   1000 * 0.13400,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 35.24,
      TEvaLvgMin =          273.15 + 5.60,
      TEvaLvgMax =          273.15 + 7.20,
      TConLvgMin =          273.15 + 30.8,
      TConLvgMax =          273.15 + 36.9,
      capFunT =             {0.403602663,-0.006794189,-0.000564953,0.046104574,-0.00117838,0.00215062},
      EIRFunT =             {1.056335684,0.045975279,0.001839862,-0.028575058,0.000935916,-0.002552237},
      EIRFunPLR =           {0.243594787,-0.017680952,0.000731787,0.848300868,-0.358252903,0.000896547,-9.0516E-06,0.736449508,0.000316148,-0.022213923},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHG670-44&amp;86 2490kW/6.5COP" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHG670-44&amp;86 2490kW/6.5COP,  !- Name
    2490036,                 !- Reference Capacity {W}
    6.505,                   !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    35.24,                   !- Reference Leaving Condenser Water Temperature {C}
    0.08894,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.13400,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHG670-44&amp;86 2490kW/6.5COP CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHG670-44&amp;86 2490kW/6.5COP EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHG670-44&amp;86 2490kW/6.5COP EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.087,                   !- Minimum Part Load Ratio
    1.001,                   !- Maximum Part Load Ratio
    0.801,                   !- Optimum Part Load Ratio
    0.087,                   !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    5.6,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    VariableFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2567100,
      COP_nominal =         11.77,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.12113,
      mCon_flow_nominal =   1000 * 0.15142,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 17.18,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.02,
      TConLvgMax =          273.15 + 35.24,
      capFunT =             {3.150690E-01,7.668658E-03,-4.348521E-03,4.998865E-02,-1.242078E-03,3.158318E-03},
      EIRFunT =             {3.654848E-01,-3.708915E-02,-7.448564E-04,4.585429E-02,1.719990E-04,-3.518960E-04},
      EIRFunPLR =           {-2.955643E-01,2.586243E-02,3.917081E-05,7.440108E-01,3.533880E-01,-2.797714E-02,0.000000E+00,2.247632E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 2567kW/11.77COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 2567kW/11.77COP/VSD,  !- Name
    2567100,                 !- Reference Capacity {W}
    11.77,                   !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    17.18,                   !- Reference Leaving Condenser Water Temperature {C}
    0.12113,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.15142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 2567kW/11.77COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2567kW/11.77COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2567kW/11.77COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_2771kW_6_84COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2771100,
      COP_nominal =         6.84,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.10094,
      mCon_flow_nominal =   1000 * 0.15142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.91,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.24,
      TConLvgMax =          273.15 + 34.26,
      capFunT =             {4.744171E-01,3.178084E-02,-1.802780E-03,5.380910E-02,-1.642699E-03,1.330445E-03},
      EIRFunT =             {8.286811E-01,2.304403E-02,-6.841126E-04,-1.886483E-02,1.088152E-03,-1.846484E-03},
      EIRFunPLR =           {-6.205477E-01,5.913283E-02,-1.627433E-05,1.051821E-01,1.413365E+00,-5.839529E-02,0.000000E+00,9.424834E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YK 2771kW/6.84COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 2771kW/6.84COP/VSD,  !- Name
    2771100,                 !- Reference Capacity {W}
    6.84,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.91,                   !- Reference Leaving Condenser Water Temperature {C}
    0.10094,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.15142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 2771kW/6.84COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 2771kW/6.84COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 2771kW/6.84COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_2799kW_6_40COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -2799200,
      COP_nominal =         6.40,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.09893,
      mCon_flow_nominal =   1000 * 0.13761,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.74,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.38,
      TConLvgMax =          273.15 + 35.07,
      capFunT =             {-2.176308E-01,-4.941294E-02,8.700615E-05,9.612083E-02,-2.027636E-03,2.538833E-03},
      EIRFunT =             {-1.986966E-02,-7.848021E-02,1.944174E-03,7.122651E-02,-9.173802E-04,5.837817E-04},
      EIRFunPLR =           {3.516172E-01,9.213025E-03,-2.382325E-05,1.223162E-01,-1.820075E-01,-7.843422E-03,0.000000E+00,6.884847E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 2799kW/6.40COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 2799kW/6.40COP/Vanes,  !- Name
    2799200,                 !- Reference Capacity {W}
    6.40,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.74,                   !- Reference Leaving Condenser Water Temperature {C}
    0.09893,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.13761,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 2799kW/6.40COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2799kW/6.40COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 2799kW/6.40COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YT_3133kW_9_16COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -3133300,
      COP_nominal =         9.16,
      PLRMin =              0.07,
      PLRMinUnl =           0.07,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.08076,
      mCon_flow_nominal =   1000 * 0.12618,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 19.37,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 19.37,
      TConLvgMax =          273.15 + 35.91,
      capFunT =             {6.112157E-01,-1.430728E-02,9.823748E-05,3.293543E-02,-1.221859E-03,2.659301E-03},
      EIRFunT =             {8.749714E-01,-2.881975E-02,2.003695E-03,7.313755E-03,5.578288E-04,-1.170615E-03},
      EIRFunPLR =           {3.389568E-01,-1.864923E-02,3.548361E-04,1.107404E+00,-5.912797E-01,-4.559304E-04,0.000000E+00,3.910858E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YT 3133kW/9.16COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YT 3133kW/9.16COP/Vanes,  !- Name
    3133300,                 !- Reference Capacity {W}
    9.16,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    19.37,                   !- Reference Leaving Condenser Water Temperature {C}
    0.08076,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.12618,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YT 3133kW/9.16COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YT 3133kW/9.16COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YT 3133kW/9.16COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.07,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.07,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PFH_3165kW_6_48COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -3165000,
      COP_nominal =         6.48,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.13627,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 29.19,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.90,
      TConLvgMax =          273.15 + 31.43,
      capFunT =             {1.575783E+00,3.340085E-02,-1.294551E-02,-2.136229E-02,-1.076276E-03,7.287288E-03},
      EIRFunT =             {1.176153E+00,2.944151E-02,-1.226585E-02,-3.542539E-02,4.663835E-04,4.521499E-03},
      EIRFunPLR =           {-1.080715E+00,7.856030E-02,-1.461231E-04,1.153308E+00,-1.705463E-01,-7.105856E-02,0.000000E+00,1.002552E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PFH 3165kW/6.48COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PFH 3165kW/6.48COP/Vanes,  !- Name
    3165000,                 !- Reference Capacity {W}
    6.48,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.19,                   !- Reference Leaving Condenser Water Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.13627,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PFH 3165kW/6.48COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 3165kW/6.48COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 3165kW/6.48COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_McQuay_PFH_4020kW_7_35COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4019500,
      COP_nominal =         7.35,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.07874,
      mCon_flow_nominal =   1000 * 0.09842,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 23.88,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 23.88,
      TConLvgMax =          273.15 + 34.13,
      capFunT =             {7.840238E-01,-2.030602E-02,-6.024097E-03,3.464466E-02,-2.015835E-03,5.876334E-03},
      EIRFunT =             {9.146197E-01,-2.888281E-02,-4.194058E-04,1.312299E-03,3.957170E-04,1.747410E-04},
      EIRFunPLR =           {-6.055569E-01,4.924519E-02,-2.046580E-05,3.574244E-01,1.429584E+00,-4.800957E-02,0.000000E+00,-1.995032E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller McQuay PFH 4020kW/7.35COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller McQuay PFH 4020kW/7.35COP/Vanes,  !- Name
    4019500,                 !- Reference Capacity {W}
    7.35,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    23.88,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07874,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09842,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller McQuay PFH 4020kW/7.35COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 4020kW/7.35COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller McQuay PFH 4020kW/7.35COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_4396kW_6_63COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4395800,
      COP_nominal =         6.63,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.58,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 18.53,
      TConLvgMax =          273.15 + 31.58,
      capFunT =             {-7.935103E-01,-1.859711E-01,-1.136209E-02,2.223615E-01,-6.910739E-03,1.608112E-02},
      EIRFunT =             {3.992978E-01,-5.787211E-02,4.974140E-04,4.071879E-02,-5.579169E-04,9.811292E-04},
      EIRFunPLR =           {3.551587E-01,-8.505111E-03,1.396120E-04,5.048375E-01,-1.447328E-01,1.902634E-03,0.000000E+00,3.599323E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 4396kW/6.63COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 4396kW/6.63COP/Vanes,  !- Name
    4395800,                 !- Reference Capacity {W}
    6.63,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.58,                   !- Reference Leaving Condenser Water Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 4396kW/6.63COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 4396kW/6.63COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 4396kW/6.63COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_4477kW_6_64COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4476700,
      COP_nominal =         6.64,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 18.50,
      TConLvgMax =          273.15 + 31.67,
      capFunT =             {-5.612561E-01,-2.094117E-01,-8.555483E-03,2.050690E-01,-6.451488E-03,1.561052E-02},
      EIRFunT =             {1.597687E-01,-3.513678E-02,-2.666547E-03,5.561175E-02,-9.273482E-04,1.559350E-03},
      EIRFunPLR =           {6.263474E-01,-1.468760E-02,2.187947E-04,-4.940077E-01,1.448597E+00,4.085582E-03,0.000000E+00,-4.576722E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 4477kW/6.64COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 4477kW/6.64COP/Vanes,  !- Name
    4476700,                 !- Reference Capacity {W}
    6.64,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.67,                   !- Reference Leaving Condenser Water Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 4477kW/6.64COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 4477kW/6.64COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 4477kW/6.64COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_4515kW_6_22COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4515400,
      COP_nominal =         6.22,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.76,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 17.15,
      TConLvgMax =          273.15 + 31.76,
      capFunT =             {2.075078E-01,-1.981043E-02,-2.892690E-03,5.881989E-02,-1.521616E-03,3.461206E-03},
      EIRFunT =             {6.011575E-01,1.661031E-02,-2.137279E-06,4.501265E-03,5.130434E-04,-1.786025E-03},
      EIRFunPLR =           {7.069612E-01,-1.915921E-02,3.601682E-04,-2.561145E-01,1.177821E+00,2.539786E-03,0.000000E+00,-4.447869E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 4515kW/6.22COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 4515kW/6.22COP/Vanes,  !- Name
    4515400,                 !- Reference Capacity {W}
    6.22,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.76,                   !- Reference Leaving Condenser Water Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 4515kW/6.22COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 4515kW/6.22COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 4515kW/6.22COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_4537kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4536500,
      COP_nominal =         6.28,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 19.77,
      TConLvgMax =          273.15 + 31.78,
      capFunT =             {1.769339E-01,8.033367E-04,-1.299649E-02,1.160227E-01,-4.192731E-03,9.339837E-03},
      EIRFunT =             {8.920183E-01,-1.501518E-02,1.467430E-03,-1.261335E-02,8.431355E-04,-1.426299E-03},
      EIRFunPLR =           {1.718938E-01,6.637990E-03,1.666991E-05,1.634153E-01,9.517270E-01,-7.705773E-03,0.000000E+00,-2.724674E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 4537kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 4537kW/6.28COP/Vanes,  !- Name
    4536500,                 !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.78,                   !- Reference Leaving Condenser Water Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 4537kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 4537kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 4537kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_4610kW_6_34COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4610300,
      COP_nominal =         6.34,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.19129,
      mCon_flow_nominal =   1000 * 0.24757,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.27,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 23.15,
      TConLvgMax =          273.15 + 34.76,
      capFunT =             {8.054195E-01,-1.086306E-02,-1.750699E-03,1.269252E-02,-3.913330E-04,1.602126E-03},
      EIRFunT =             {6.849506E-01,-4.909207E-02,-8.308126E-04,1.199218E-02,1.642681E-04,6.761764E-04},
      EIRFunPLR =           {-7.113458E-02,1.278078E-02,-1.151552E-05,1.228548E+00,-1.065066E+00,-1.209695E-02,0.000000E+00,8.979381E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 4610kW/6.34COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 4610kW/6.34COP/Vanes,  !- Name
    4610300,                 !- Reference Capacity {W}
    6.34,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.27,                   !- Reference Leaving Condenser Water Temperature {C}
    0.19129,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24757,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 4610kW/6.34COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 4610kW/6.34COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 4610kW/6.34COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19EX_4667kW_6_16COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4666600,
      COP_nominal =         6.16,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.94,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 17.77,
      TConLvgMax =          273.15 + 31.94,
      capFunT =             {-8.915725E-02,-6.491327E-02,-3.356680E-03,1.108472E-01,-3.034272E-03,5.648135E-03},
      EIRFunT =             {5.382224E-01,2.679869E-03,4.713078E-04,7.901564E-03,4.567647E-04,-1.386795E-03},
      EIRFunPLR =           {5.967050E-01,-1.472448E-02,4.216331E-05,3.682618E-01,-2.379422E-01,1.262951E-02,0.000000E+00,2.973345E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes,  !- Name
    4666600,                 !- Reference Capacity {W}
    6.16,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.94,                   !- Reference Leaving Condenser Water Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CVHF_4677kW_6_27COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4677100,
      COP_nominal =         6.27,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.20138,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.94,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 17.51,
      TConLvgMax =          273.15 + 31.94,
      capFunT =             {8.138295E-01,-2.315871E-02,6.181089E-03,8.639578E-03,-1.807173E-04,-5.015921E-05},
      EIRFunT =             {8.371931E-01,-1.837487E-02,3.992101E-03,-8.582353E-03,6.821892E-04,-1.443699E-03},
      EIRFunPLR =           {-3.243462E-01,1.463635E-02,-8.320365E-05,1.978667E+00,-2.019795E+00,-1.072468E-02,0.000000E+00,1.320583E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CVHF 4677kW/6.27COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CVHF 4677kW/6.27COP/Vanes,  !- Name
    4677100,                 !- Reference Capacity {W}
    6.27,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.94,                   !- Reference Leaving Condenser Water Temperature {C}
    0.20138,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CVHF 4677kW/6.27COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 4677kW/6.27COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CVHF 4677kW/6.27COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_4966kW_6_05COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4965500,
      COP_nominal =         6.05,
      PLRMin =              0.12,
      PLRMinUnl =           0.12,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.21198,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.33,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.07,
      TConLvgMax =          273.15 + 35.01,
      capFunT =             {4.672989E-01,-3.881077E-02,-2.462607E-04,3.605453E-02,-8.010103E-04,2.190852E-03},
      EIRFunT =             {8.536699E-01,3.487393E-04,1.120994E-03,-9.358730E-03,6.197745E-04,-1.128239E-03},
      EIRFunPLR =           {2.620385E-01,1.209698E-02,8.014586E-06,-1.102167E-01,1.117062E+00,-1.249449E-02,0.000000E+00,-2.641246E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 4966kW/6.05COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 4966kW/6.05COP/Vanes,  !- Name
    4965500,                 !- Reference Capacity {W}
    6.05,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.33,                   !- Reference Leaving Condenser Water Temperature {C}
    0.21198,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 4966kW/6.05COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 4966kW/6.05COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 4966kW/6.05COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.12,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.12,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_4969kW_7_14COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4969000,
      COP_nominal =         7.14,
      PLRMin =              0.16,
      PLRMinUnl =           0.16,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.17665,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.23,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.57,
      TConLvgMax =          273.15 + 34.55,
      capFunT =             {2.811615E-03,-1.788883E-01,-4.640550E-03,1.472024E-01,-4.625224E-03,1.108352E-02},
      EIRFunT =             {6.916913E-01,-4.760980E-02,1.310678E-03,1.226839E-02,1.561278E-04,1.331849E-04},
      EIRFunPLR =           {3.289463E-01,6.642124E-03,-2.636011E-05,-4.910925E-01,1.639401E+00,-5.204880E-03,0.000000E+00,-4.960251E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 4969kW/7.14COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 4969kW/7.14COP/Vanes,  !- Name
    4969000,                 !- Reference Capacity {W}
    7.14,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.23,                   !- Reference Leaving Condenser Water Temperature {C}
    0.17665,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 4969kW/7.14COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 4969kW/7.14COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 4969kW/7.14COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.16,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.16,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_4969kW_7_07COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4969000,
      COP_nominal =         7.07,
      PLRMin =              0.16,
      PLRMinUnl =           0.16,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.17665,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.23,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.30,
      TConLvgMax =          273.15 + 34.56,
      capFunT =             {-1.238406E+00,-2.167075E-01,-9.525838E-03,2.481491E-01,-6.930334E-03,1.495974E-02},
      EIRFunT =             {7.217115E-01,-3.596981E-02,5.327502E-04,9.190024E-03,1.694811E-04,1.843438E-04},
      EIRFunPLR =           {7.117270E-01,1.022191E-03,1.205226E-05,-1.794131E+00,3.295736E+00,-1.552001E-03,0.000000E+00,-1.207188E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 4969kW/7.07COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 4969kW/7.07COP/Vanes,  !- Name
    4969000,                 !- Reference Capacity {W}
    7.07,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.23,                   !- Reference Leaving Condenser Water Temperature {C}
    0.17665,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 4969kW/7.07COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 4969kW/7.07COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 4969kW/7.07COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.16,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.16,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19EX_4997kW_6_40COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -4997200,
      COP_nominal =         6.40,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 32.28,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 17.18,
      TConLvgMax =          273.15 + 32.28,
      capFunT =             {-2.686142E-01,-4.640249E-02,-7.791139E-03,1.116057E-01,-3.040750E-03,6.823316E-03},
      EIRFunT =             {7.502378E-01,-8.546174E-03,3.952892E-03,-7.194001E-03,8.754798E-04,-2.523240E-03},
      EIRFunPLR =           {6.778244E-01,-1.674571E-02,-1.069925E-05,2.261951E-01,-1.572357E-02,1.714268E-02,0.000000E+00,1.072291E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes,  !- Name
    4997200,                 !- Reference Capacity {W}
    6.40,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    32.28,                   !- Reference Leaving Condenser Water Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19EX_5148kW_6_34COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -5148400,
      COP_nominal =         6.34,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.18283,
      mCon_flow_nominal =   1000 * 0.25526,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.70,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.87,
      TConLvgMax =          273.15 + 34.96,
      capFunT =             {-1.011196E-01,-1.084580E-02,-6.804354E-03,8.869769E-02,-2.343514E-03,4.796955E-03},
      EIRFunT =             {6.139244E-01,1.237345E-02,8.199573E-04,6.805078E-04,6.221886E-04,-1.797776E-03},
      EIRFunPLR =           {2.989462E-01,-1.736649E-02,1.922011E-05,1.534120E+00,-1.596922E+00,1.630424E-02,0.000000E+00,7.776844E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes,  !- Name
    5148400,                 !- Reference Capacity {W}
    6.34,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.70,                   !- Reference Leaving Condenser Water Temperature {C}
    0.18283,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.25526,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_5170kW_7_15COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -5169500,
      COP_nominal =         7.15,
      PLRMin =              0.15,
      PLRMinUnl =           0.15,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.17665,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.43,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.30,
      TConLvgMax =          273.15 + 34.88,
      capFunT =             {-1.064004E+00,-2.233223E-01,-7.441205E-03,2.281866E-01,-6.268922E-03,1.390983E-02},
      EIRFunT =             {5.056958E-01,-2.296962E-02,-1.632795E-03,2.230325E-02,-1.548393E-04,8.256108E-04},
      EIRFunPLR =           {7.949169E-01,9.107817E-04,3.483284E-05,-2.015044E+00,3.394622E+00,-2.646463E-03,0.000000E+00,-1.152785E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 5170kW/7.15COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 5170kW/7.15COP/Vanes,  !- Name
    5169500,                 !- Reference Capacity {W}
    7.15,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.43,                   !- Reference Leaving Condenser Water Temperature {C}
    0.17665,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 5170kW/7.15COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 5170kW/7.15COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 5170kW/7.15COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.15,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.15,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19EX_5208kW_6_88COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -5208200,
      COP_nominal =         6.88,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.18283,
      mCon_flow_nominal =   1000 * 0.25293,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.75,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.08,
      TConLvgMax =          273.15 + 35.31,
      capFunT =             {1.254471E-01,-1.028175E-01,-4.242764E-03,9.372985E-02,-2.733787E-03,7.161423E-03},
      EIRFunT =             {5.363910E-01,-8.005283E-04,-2.759052E-05,7.405978E-03,4.159925E-04,-8.731268E-04},
      EIRFunPLR =           {3.759577E-01,-1.540144E-02,6.020001E-05,1.240869E+00,-1.267595E+00,1.195934E-02,0.000000E+00,6.977113E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes,  !- Name
    5208200,                 !- Reference Capacity {W}
    6.88,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.75,                   !- Reference Leaving Condenser Water Temperature {C}
    0.18283,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.25293,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_5465kW_6_94COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -5464900,
      COP_nominal =         6.94,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.18296,
      mCon_flow_nominal =   1000 * 0.27444,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.56,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.03,
      TConLvgMax =          273.15 + 34.99,
      capFunT =             {-1.004987E+00,-2.020843E-01,-5.768143E-03,2.096972E-01,-5.537991E-03,1.195948E-02},
      EIRFunT =             {5.844853E-01,-4.786810E-02,7.315110E-04,2.167930E-02,-8.850313E-05,5.184829E-04},
      EIRFunPLR =           {8.903067E-01,-1.058205E-03,4.591261E-05,-2.096863E+00,3.368956E+00,-1.380690E-03,0.000000E+00,-1.130250E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 5465kW/6.94COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 5465kW/6.94COP/Vanes,  !- Name
    5464900,                 !- Reference Capacity {W}
    6.94,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.56,                   !- Reference Leaving Condenser Water Temperature {C}
    0.18296,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.27444,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 5465kW/6.94COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 5465kW/6.94COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 5465kW/6.94COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YK_5549kW_6_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -5549300,
      COP_nominal =         6.50,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.18296,
      mCon_flow_nominal =   1000 * 0.27444,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 31.69,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 18.38,
      TConLvgMax =          273.15 + 31.70,
      capFunT =             {-8.620027E-01,6.692796E-03,-4.020156E-03,1.550060E-01,-3.586968E-03,3.027128E-03},
      EIRFunT =             {3.302868E-01,-8.254126E-02,6.087519E-03,4.875213E-02,-5.839053E-04,-5.006909E-05},
      EIRFunPLR =           {5.179058E-01,-2.419877E-03,4.858626E-05,-8.910290E-01,2.272953E+00,-3.062303E-04,0.000000E+00,-8.631289E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YK 5549kW/6.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YK 5549kW/6.50COP/Vanes,  !- Name
    5549300,                 !- Reference Capacity {W}
    6.50,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    31.69,                   !- Reference Leaving Condenser Water Temperature {C}
    0.18296,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.27444,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YK 5549kW/6.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YK 5549kW/6.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YK 5549kW/6.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_19FA_5651kW_5_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -5651300,
      COP_nominal =         5.50,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.18927,
      mCon_flow_nominal =   1000 * 0.18927,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 37.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 26.23,
      TConLvgMax =          273.15 + 39.12,
      capFunT =             {9.205097E-01,-7.830750E-02,-4.545053E-03,5.853135E-02,-2.108693E-03,6.359267E-03},
      EIRFunT =             {8.804871E-01,3.853907E-04,2.224949E-04,-1.337560E-02,5.822842E-04,-8.744742E-04},
      EIRFunPLR =           {-1.360532E-01,8.642703E-03,3.855583E-06,1.024034E+00,6.047444E-02,-8.947860E-03,0.000000E+00,5.706602E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes,  !- Name
    5651300,                 !- Reference Capacity {W}
    5.50,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    37.89,                   !- Reference Leaving Condenser Water Temperature {C}
    0.18927,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.18927,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Multistack_MS_172kW_3_67COP_None =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -172300,
      COP_nominal =         3.67,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.00738,
      mCon_flow_nominal =   1000 * 0.00959,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 23.82,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 23.82,
      TConLvgMax =          273.15 + 40.51,
      capFunT =             {1.127280E+00,1.221754E-01,-4.746140E-03,-2.833951E-02,3.021524E-04,-6.616494E-04},
      EIRFunT =             {8.822430E-01,-6.747171E-02,3.070641E-03,1.073323E-02,1.721572E-04,2.401500E-05},
      EIRFunPLR =           {4.368265E-01,-2.032253E-02,1.212838E-05,5.892153E-01,4.814951E-01,1.957982E-02,0.000000E+00,-4.971216E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Multistack MS 172kW/3.67COP/None" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Multistack MS 172kW/3.67COP/None,  !- Name
    172300,                  !- Reference Capacity {W}
    3.67,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    23.82,                   !- Reference Leaving Condenser Water Temperature {C}
    0.00738,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.00959,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Multistack MS 172kW/3.67COP/None CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Multistack MS 172kW/3.67COP/None EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Multistack MS 172kW/3.67COP/None EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTWA_383kW_4_17COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -383300,
      COP_nominal =         4.17,
      PLRMin =              0.25,
      PLRMinUnl =           0.25,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.0165,
      mCon_flow_nominal =   1000 * 0.02063,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.95,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 29.19,
      TConLvgMax =          273.15 + 40.69,
      capFunT =             {1.005026E+00,3.896773E-02,9.270374E-05,-4.346837E-03,-4.961570E-05,-2.401448E-04},
      EIRFunT =             {6.171417E-01,-4.530431E-03,1.108471E-03,-3.373738E-04,5.176833E-04,-1.098531E-03},
      EIRFunPLR =           {-1.660765E+00,1.117605E-01,4.971509E-06,-3.472160E-02,3.399869E+00,-1.121089E-01,0.000000E+00,-6.984388E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTWA 383kW/4.17COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTWA 383kW/4.17COP/Valve,  !- Name
    383300,                  !- Reference Capacity {W}
    4.17,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.95,                   !- Reference Leaving Condenser Water Temperature {C}
    0.0165,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.02063,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTWA 383kW/4.17COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTWA 383kW/4.17COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTWA 383kW/4.17COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.25,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.25,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHB_531kW_4_83COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -531000,
      COP_nominal =         4.83,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.0135,
      mCon_flow_nominal =   1000 * 0.01577,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 33.61,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 25.39,
      TConLvgMax =          273.15 + 34.83,
      capFunT =             {9.079958E-01,1.147213E-02,8.474223E-04,7.750840E-03,-2.955319E-04,3.620562E-04},
      EIRFunT =             {3.048223E-01,1.023123E-02,2.011952E-04,1.296369E-02,4.087926E-04,-1.374337E-03},
      EIRFunPLR =           {4.560311E+00,-2.031290E-01,8.212225E-05,-4.899042E+00,5.087775E+00,1.981069E-01,0.000000E+00,-3.673772E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHB 531kW/4.83COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHB 531kW/4.83COP/Valve,  !- Name
    531000,                  !- Reference Capacity {W}
    4.83,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    33.61,                   !- Reference Leaving Condenser Water Temperature {C}
    0.0135,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.01577,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHB 531kW/4.83COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 531kW/4.83COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 531kW/4.83COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHB_538kW_5_12COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -538000,
      COP_nominal =         5.12,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01375,
      mCon_flow_nominal =   1000 * 0.01956,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.75,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 23.52,
      TConLvgMax =          273.15 + 32.74,
      capFunT =             {9.326777E-01,2.745642E-02,3.991103E-04,1.073891E-03,-1.335614E-04,1.399941E-05},
      EIRFunT =             {4.761769E-01,-3.860230E-03,6.543433E-04,7.029128E-03,4.964676E-04,-1.113233E-03},
      EIRFunPLR =           {2.185505E+00,-9.516501E-02,2.591946E-05,-1.849602E+00,2.059148E+00,9.366870E-02,0.000000E+00,-1.373917E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHB 538kW/5.12COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHB 538kW/5.12COP/Valve,  !- Name
    538000,                  !- Reference Capacity {W}
    5.12,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.75,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01375,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01956,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHB 538kW/5.12COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 538kW/5.12COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 538kW/5.12COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHB_542kW_5_26COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -541500,
      COP_nominal =         5.26,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01363,
      mCon_flow_nominal =   1000 * 0.01577,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 30.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 25.39,
      TConLvgMax =          273.15 + 34.83,
      capFunT =             {9.292432E-01,2.977220E-02,4.279686E-04,-1.825578E-04,-9.143496E-05,-8.471843E-05},
      EIRFunT =             {2.877196E-01,-1.191161E-02,7.252148E-04,2.352346E-02,2.033310E-04,-9.517160E-04},
      EIRFunPLR =           {1.837065E+00,-7.719197E-02,-1.307430E-06,-1.063492E+00,6.874543E-01,7.728359E-02,0.000000E+00,-4.626311E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHB 542kW/5.26COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHB 542kW/5.26COP/Valve,  !- Name
    541500,                  !- Reference Capacity {W}
    5.26,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    30.89,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01363,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01577,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHB 542kW/5.26COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 542kW/5.26COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 542kW/5.26COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YS_672kW_7_90COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -671600,
      COP_nominal =         7.90,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01514,
      mCon_flow_nominal =   1000 * 0.0241,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 23.07,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 23.07,
      TConLvgMax =          273.15 + 32.60,
      capFunT =             {9.653043E-01,3.117948E-02,4.747822E-04,-5.778354E-03,-1.229225E-05,-2.348690E-04},
      EIRFunT =             {1.199355E-01,-6.676229E-03,4.330599E-04,4.300726E-02,1.757823E-04,-1.325426E-03},
      EIRFunPLR =           {7.456160E-01,-2.835399E-02,9.054026E-06,-3.984299E-01,2.016392E+00,2.785056E-02,0.000000E+00,-1.356679E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YS 672kW/7.90COP/Valve"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YS 672kW/7.90COP/Valve,  !- Name
    671600,                  !- Reference Capacity {W}
    7.90,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    23.07,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01514,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0241,                  !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YS 672kW/7.90COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YS 672kW/7.90COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YS 672kW/7.90COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_686kW_5_91COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -685700,
      COP_nominal =         5.91,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.0571,
      mCon_flow_nominal =   1000 * 0.03255,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 29.63,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 17.39,
      TConLvgMax =          273.15 + 30.39,
      capFunT =             {1.248877E-02,-3.890734E-02,-4.482589E-03,8.632797E-02,-2.289350E-03,4.755520E-03},
      EIRFunT =             {5.449412E-01,1.058205E-02,5.610010E-04,4.494100E-04,7.827776E-04,-1.787673E-03},
      EIRFunPLR =           {3.479846E-01,-1.132553E-03,-5.082473E-05,1.944353E-01,6.340539E-01,3.457251E-03,0.000000E+00,-2.025127E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 686kW/5.91COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 686kW/5.91COP/Valve,  !- Name
    685700,                  !- Reference Capacity {W}
    5.91,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    29.63,                   !- Reference Leaving Condenser Water Temperature {C}
    0.0571,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.03255,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 686kW/5.91COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 686kW/5.91COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 686kW/5.91COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHC_707kW_7_77COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -706800,
      COP_nominal =         7.77,
      PLRMin =              0.28,
      PLRMinUnl =           0.28,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04921,
      mCon_flow_nominal =   1000 * 0.03268,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 21.40,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 11.11,
      TConLvgMin =          273.15 + 21.40,
      TConLvgMax =          273.15 + 30.31,
      capFunT =             {9.650754E-01,3.116480E-02,6.283163E-04,-5.158701E-03,-5.981975E-05,-1.623288E-04},
      EIRFunT =             {5.777406E-01,1.234139E-02,-3.550380E-04,9.871073E-03,7.225565E-04,-1.521275E-03},
      EIRFunPLR =           {4.383290E+00,-1.536137E-01,-3.825029E-05,-4.911866E+00,3.331498E+00,1.554529E-01,0.000000E+00,-1.824968E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHC 707kW/7.77COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHC 707kW/7.77COP/Valve,  !- Name
    706800,                  !- Reference Capacity {W}
    7.77,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    21.40,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04921,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03268,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHC 707kW/7.77COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 707kW/7.77COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 707kW/7.77COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.28,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.28,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YS_756kW_7_41COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -756000,
      COP_nominal =         7.41,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 20.05,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 20.05,
      TConLvgMax =          273.15 + 28.28,
      capFunT =             {9.642889E-01,2.866413E-02,3.109129E-04,-5.631322E-03,-3.762572E-05,-5.237190E-05},
      EIRFunT =             {6.354619E-01,-1.370325E-02,1.593968E-03,1.156358E-02,9.449231E-04,-1.967502E-03},
      EIRFunPLR =           {-1.261074E+00,1.245378E-01,-1.028560E-04,6.936120E-01,5.828942E-01,-1.203584E-01,0.000000E+00,9.427000E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YS 756kW/7.41COP/Valve"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YS 756kW/7.41COP/Valve,  !- Name
    756000,                  !- Reference Capacity {W}
    7.41,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    20.05,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YS 756kW/7.41COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YS 756kW/7.41COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YS 756kW/7.41COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YS_781kW_5_42COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -780700,
      COP_nominal =         5.42,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01893,
      mCon_flow_nominal =   1000 * 0.03785,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 35.29,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 21.31,
      TConLvgMax =          273.15 + 41.08,
      capFunT =             {1.033403E+00,3.515774E-02,4.288264E-04,-5.737406E-03,-2.647149E-05,-2.222927E-04},
      EIRFunT =             {4.008316E-01,-6.141937E-03,8.113800E-04,5.982224E-03,5.345503E-04,-1.142919E-03},
      EIRFunPLR =           {5.519460E-01,-1.406889E-02,3.843199E-06,7.950267E-02,8.798848E-01,1.379480E-02,0.000000E+00,-5.070156E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YS 781kW/5.42COP/Valve"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YS 781kW/5.42COP/Valve,  !- Name
    780700,                  !- Reference Capacity {W}
    5.42,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    35.29,                   !- Reference Leaving Condenser Water Temperature {C}
    0.01893,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03785,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YS 781kW/5.42COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YS 781kW/5.42COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YS 781kW/5.42COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_830kW_6_97COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -829900,
      COP_nominal =         6.97,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04744,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 28.67,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 18.74,
      TConLvgMax =          273.15 + 28.78,
      capFunT =             {7.593802E-01,3.128246E-03,-2.461755E-04,1.648515E-02,-3.342693E-04,2.498119E-04},
      EIRFunT =             {3.680542E-01,-1.666432E-02,-2.427956E-04,2.515814E-02,-4.357417E-05,1.578686E-04},
      EIRFunPLR =           {8.035259E-01,-2.731638E-02,3.311687E-05,-3.801212E-01,1.805184E+00,2.602604E-02,0.000000E+00,-1.216514E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 830kW/6.97COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 830kW/6.97COP/Valve,  !- Name
    829900,                  !- Reference Capacity {W}
    6.97,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    28.67,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04744,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 830kW/6.97COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 830kW/6.97COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 830kW/6.97COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_862kW_6_11COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -861500,
      COP_nominal =         6.11,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04296,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 29.47,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 16.41,
      TConLvgMax =          273.15 + 29.48,
      capFunT =             {-2.979107E-01,-5.151176E-02,-3.383830E-03,1.108248E-01,-2.569743E-03,3.803707E-03},
      EIRFunT =             {6.091020E-01,-1.121376E-02,1.911380E-03,3.134795E-03,7.602337E-04,-1.864480E-03},
      EIRFunPLR =           {8.107206E-01,-2.005785E-02,-4.533858E-05,-9.361992E-01,2.154755E+00,2.196099E-02,0.000000E+00,-1.048282E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 862kW/6.11COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 862kW/6.11COP/Valve,  !- Name
    861500,                  !- Reference Capacity {W}
    6.11,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.47,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04296,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 862kW/6.11COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 862kW/6.11COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 862kW/6.11COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_862kW_6_84COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -861500,
      COP_nominal =         6.84,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04296,
      TEvaLvg_nominal =     273.15 + 9.69,
      TConLvg_nominal =     273.15 + 29.39,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 16.41,
      TConLvgMax =          273.15 + 29.48,
      capFunT =             {-3.092995E-01,-5.286556E-02,-3.325673E-03,1.124372E-01,-2.612023E-03,3.825379E-03},
      EIRFunT =             {6.678615E-01,-9.383184E-03,2.032594E-03,3.679404E-03,8.601638E-04,-2.160177E-03},
      EIRFunPLR =           {8.851376E-01,-3.243560E-02,1.524188E-05,-4.919407E-01,1.397112E+00,3.165504E-02,0.000000E+00,-7.803717E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 862kW/6.84COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 862kW/6.84COP/Valve,  !- Name
    861500,                  !- Reference Capacity {W}
    6.84,                    !- Reference COP {W/W}
    9.69,                    !- Reference Leaving Chilled Water Temperature {C}
    29.39,                   !- Reference Leaving Condenser Water Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04296,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 862kW/6.84COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 862kW/6.84COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 862kW/6.84COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_865kW_6_05COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -865100,
      COP_nominal =         6.05,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03716,
      mCon_flow_nominal =   1000 * 0.04366,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 31.63,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 16.50,
      TConLvgMax =          273.15 + 35.26,
      capFunT =             {4.094927E-01,-2.603658E-02,-3.192164E-03,3.484958E-02,-6.572290E-04,2.194642E-03},
      EIRFunT =             {5.716056E-01,1.224643E-02,5.618829E-04,-5.486870E-03,7.739394E-04,-1.685380E-03},
      EIRFunPLR =           {-1.633484E-01,2.429348E-02,-1.563508E-05,1.196860E+00,-8.284241E-01,-2.352693E-02,0.000000E+00,7.855871E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 865kW/6.05COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 865kW/6.05COP/Valve,  !- Name
    865100,                  !- Reference Capacity {W}
    6.05,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    31.63,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03716,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04366,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 865kW/6.05COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 865kW/6.05COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 865kW/6.05COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YS_879kW_5_82COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -879100,
      COP_nominal =         5.82,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConLvg_nominal =     273.15 + 31.32,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConLvgMin =          273.15 + 18.15,
      TConLvgMax =          273.15 + 35.12,
      capFunT =             {1.043132E+00,3.207323E-02,-3.372567E-04,-1.802731E-03,-1.730238E-04,3.613008E-04},
      EIRFunT =             {5.260798E-01,-4.729537E-03,1.121823E-03,4.291045E-03,5.493614E-04,-1.453233E-03},
      EIRFunPLR =           {3.727519E-01,1.350521E-04,7.654504E-07,1.088683E-02,1.106991E+00,-1.844203E-04,0.000000E+00,-4.899729E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0) "ReformEIRChiller York YS 879kW/5.82COP/Valve"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YS 879kW/5.82COP/Valve,  !- Name
    879100,                  !- Reference Capacity {W}
    5.82,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    31.32,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YS 879kW/5.82COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YS 879kW/5.82COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YS 879kW/5.82COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHC_1009kW_5_37COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1009200,
      COP_nominal =         5.37,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04618,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 31.06,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 26.58,
      TConLvgMax =          273.15 + 31.91,
      capFunT =             {1.207602E+00,3.634622E-02,6.331495E-04,-1.093985E-02,-4.376284E-05,-2.763827E-04},
      EIRFunT =             {4.985801E-01,2.197522E-02,8.236831E-04,-1.956953E-02,1.366952E-03,-2.067504E-03},
      EIRFunPLR =           {1.618518E+00,-6.247569E-02,2.022982E-04,-1.604864E+00,3.518625E+00,5.149642E-02,0.000000E+00,-2.383742E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHC 1009kW/5.37COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHC 1009kW/5.37COP/Valve,  !- Name
    1009200,                 !- Reference Capacity {W}
    5.37,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    31.06,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04618,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHC 1009kW/5.37COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 1009kW/5.37COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 1009kW/5.37COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHB_1051kW_5_05COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1051400,
      COP_nominal =         5.05,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04527,
      mCon_flow_nominal =   1000 * 0.05659,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.77,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 28.94,
      TConLvgMax =          273.15 + 40.58,
      capFunT =             {9.638196E-01,3.356030E-02,-6.697810E-05,-3.142817E-03,-6.684016E-05,1.841742E-05},
      EIRFunT =             {4.638880E-01,7.313353E-04,1.440483E-03,3.400471E-03,6.072397E-04,-1.656400E-03},
      EIRFunPLR =           {-2.132575E+01,7.315041E-01,1.435460E-05,1.774494E+01,5.234092E+00,-7.325017E-01,0.000000E+00,-6.363903E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHB 1051kW/5.05COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHB 1051kW/5.05COP/Valve,  !- Name
    1051400,                 !- Reference Capacity {W}
    5.05,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.77,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04527,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05659,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHB 1051kW/5.05COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 1051kW/5.05COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHB 1051kW/5.05COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_1062kW_5_50COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1062000,
      COP_nominal =         5.50,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04573,
      mCon_flow_nominal =   1000 * 0.05716,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.70,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 26.44,
      TConLvgMax =          273.15 + 35.10,
      capFunT =             {1.054485E+00,1.015650E-02,-4.899041E-03,-3.792726E-03,-3.699876E-04,2.891276E-03},
      EIRFunT =             {1.369592E-01,-5.681693E-03,2.795150E-04,2.407603E-02,2.142516E-04,-8.850727E-04},
      EIRFunPLR =           {1.385765E+00,-3.549685E-02,-4.110930E-06,-7.678018E-01,7.228808E-01,3.573245E-02,0.000000E+00,-3.442173E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 1062kW/5.50COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 1062kW/5.50COP/Valve,  !- Name
    1062000,                 !- Reference Capacity {W}
    5.50,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.70,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04573,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05716,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 1062kW/5.50COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 1062kW/5.50COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 1062kW/5.50COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHC_1066kW_5_73COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1065500,
      COP_nominal =         5.73,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.05142,
      mCon_flow_nominal =   1000 * 0.04416,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 32.06,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 27.08,
      TConLvgMax =          273.15 + 33.00,
      capFunT =             {1.132006E+00,5.350322E-02,4.674089E-04,-9.696767E-03,-1.092622E-05,-6.864058E-04},
      EIRFunT =             {1.270619E+00,2.714576E-02,1.314069E-03,-7.074240E-02,2.188506E-03,-2.478095E-03},
      EIRFunPLR =           {-5.639468E-01,3.938489E-02,1.732511E-04,1.260815E+00,8.111637E-01,-4.893450E-02,0.000000E+00,-3.768289E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHC 1066kW/5.73COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHC 1066kW/5.73COP/Valve,  !- Name
    1065500,                 !- Reference Capacity {W}
    5.73,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    32.06,                   !- Reference Leaving Condenser Water Temperature {C}
    0.05142,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04416,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHC 1066kW/5.73COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 1066kW/5.73COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 1066kW/5.73COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_RTHC_1094kW_6_55COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1093600,
      COP_nominal =         6.55,
      PLRMin =              0.25,
      PLRMinUnl =           0.25,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04921,
      mCon_flow_nominal =   1000 * 0.04524,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 30.00,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 22.50,
      TConLvgMax =          273.15 + 31.57,
      capFunT =             {9.937063E-01,4.121201E-02,5.647147E-04,-4.466726E-03,-6.255209E-05,-2.959437E-04},
      EIRFunT =             {6.406305E-01,-4.941735E-03,8.316386E-04,-1.042529E-03,6.666939E-04,-1.259813E-03},
      EIRFunPLR =           {-5.793160E-01,4.173392E-02,1.563673E-05,1.609363E+00,-3.325578E-01,-4.262129E-02,0.000000E+00,3.149494E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane RTHC 1094kW/6.55COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane RTHC 1094kW/6.55COP/Valve,  !- Name
    1093600,                 !- Reference Capacity {W}
    6.55,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    30.00,                   !- Reference Leaving Condenser Water Temperature {C}
    0.04921,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04524,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane RTHC 1094kW/6.55COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 1094kW/6.55COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane RTHC 1094kW/6.55COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.25,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.25,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_1108kW_6_92COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1107700,
      COP_nominal =         6.92,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.0571,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 8.97,
      TConLvg_nominal =     273.15 + 29.64,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 18.28,
      TConLvgMax =          273.15 + 30.24,
      capFunT =             {5.158330E-01,-2.311637E-02,-7.013270E-04,4.106942E-02,-1.177302E-03,2.292450E-03},
      EIRFunT =             {5.272297E-01,-1.879890E-02,1.120482E-03,1.100352E-02,6.338503E-04,-1.251189E-03},
      EIRFunPLR =           {2.638449E+00,-1.139810E-01,-1.028538E-04,-2.382279E+00,2.715083E+00,1.187905E-01,0.000000E+00,-2.025240E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 1108kW/6.92COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 1108kW/6.92COP/Valve,  !- Name
    1107700,                 !- Reference Capacity {W}
    6.92,                    !- Reference COP {W/W}
    8.97,                    !- Reference Leaving Chilled Water Temperature {C}
    29.64,                   !- Reference Leaving Condenser Water Temperature {C}
    0.0571,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 1108kW/6.92COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 1108kW/6.92COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 1108kW/6.92COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YS_1171kW_9_15COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1171000,
      COP_nominal =         9.15,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03249,
      mCon_flow_nominal =   1000 * 0.05173,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConLvg_nominal =     273.15 + 21.56,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConLvgMin =          273.15 + 21.56,
      TConLvgMax =          273.15 + 30.78,
      capFunT =             {9.337294E-01,1.920636E-02,-6.115577E-04,-7.771906E-04,-2.483077E-04,7.872535E-04},
      EIRFunT =             {3.293911E-01,-2.105626E-02,1.769048E-03,3.636950E-02,4.158157E-04,-1.853560E-03},
      EIRFunPLR =           {-2.154861E-01,3.786873E-02,-1.127341E-05,2.109726E-01,1.287825E+00,-3.728032E-02,0.000000E+00,-2.909471E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YS 1171kW/9.15COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YS 1171kW/9.15COP/Valve,  !- Name
    1171000,                 !- Reference Capacity {W}
    9.15,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    21.56,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03249,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05173,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YS 1171kW/9.15COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YS 1171kW/9.15COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YS 1171kW/9.15COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Carrier_23XL_1196kW_6_39COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1195600,
      COP_nominal =         6.39,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03653,
      mCon_flow_nominal =   1000 * 0.04271,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConLvg_nominal =     273.15 + 31.63,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConLvgMin =          273.15 + 20.39,
      TConLvgMax =          273.15 + 32.63,
      capFunT =             {3.031420E-01,6.667912E-03,-3.704014E-03,5.246809E-02,-1.408858E-03,2.775625E-03},
      EIRFunT =             {5.152368E-01,-1.274543E-02,1.116484E-03,5.217358E-03,6.656740E-04,-1.353664E-03},
      EIRFunPLR =           {-2.737954E-01,2.822257E-02,-8.097657E-05,9.612284E-01,3.029741E-01,-2.421933E-02,0.000000E+00,-3.885224E-02,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Carrier 23XL 1196kW/6.39COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Carrier 23XL 1196kW/6.39COP/Valve,  !- Name
    1195600,                 !- Reference Capacity {W}
    6.39,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    31.63,                   !- Reference Leaving Condenser Water Temperature {C}
    0.03653,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04271,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Carrier 23XL 1196kW/6.39COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 1196kW/6.39COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Carrier 23XL 1196kW/6.39COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_York_YS_1554kW_9_31COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1554300,
      COP_nominal =         9.31,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.0424,
      mCon_flow_nominal =   1000 * 0.07949,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConLvg_nominal =     273.15 + 20.74,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 20.74,
      TConLvgMax =          273.15 + 40.06,
      capFunT =             {1.158269E+00,9.811289E-03,1.227091E-03,-1.535445E-02,9.922966E-05,5.323659E-05},
      EIRFunT =             {3.556656E-01,2.393674E-02,-1.681332E-04,2.367290E-02,7.263583E-04,-2.267522E-03},
      EIRFunPLR =           {3.590292E-01,-5.404650E-03,-2.016784E-05,-2.714668E-01,2.061858E+00,6.725648E-03,0.000000E+00,-1.170629E+00,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YS 1554kW/9.31COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YS 1554kW/9.31COP/Valve,  !- Name
    1554300,                 !- Reference Capacity {W}
    9.31,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    20.74,                   !- Reference Leaving Condenser Water Temperature {C}
    0.0424,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.07949,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YS 1554kW/9.31COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YS 1554kW/9.31COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YS 1554kW/9.31COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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
</pre>
</html>"));

  record ReformEIRChiller_York_YS_1758kW_5_84COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.84,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 34.65,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConLvgMin =          273.15 + 17.74,
      TConLvgMax =          273.15 + 39.72,
      capFunT =             {6.348511E-01,-2.523830E-02,-1.840036E-03,3.830396E-02,-9.961929E-04,1.906565E-03},
      EIRFunT =             {7.492787E-01,1.912506E-02,1.303486E-03,-1.981703E-02,1.003666E-03,-1.936814E-03},
      EIRFunPLR =           {-1.522140E-01,2.440667E-02,-5.691764E-05,4.875495E-01,7.490485E-01,-2.093720E-02,0.000000E+00,-1.319819E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller York YS 1758kW/5.84COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller York YS 1758kW/5.84COP/Valve,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.84,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    34.65,                   !- Reference Leaving Condenser Water Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller York YS 1758kW/5.84COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller York YS 1758kW/5.84COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller York YS 1758kW/5.84COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

  record ReformEIRChiller_Trane_CGWD_207kW_3_99COP_None =
    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic (
      QEva_flow_nominal =  -207400,
      COP_nominal =         3.99,
      PLRMin =              0.25,
      PLRMinUnl =           0.25,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.00898,
      mCon_flow_nominal =   1000 * 0.01122,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConLvg_nominal =     273.15 + 35.00,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConLvgMin =          273.15 + 29.37,
      TConLvgMax =          273.15 + 40.94,
      capFunT =             {9.585465E-01,3.516870E-02,1.246624E-04,-2.745559E-03,-5.000232E-05,-1.723494E-04},
      EIRFunT =             {7.327001E-01,-8.343605E-03,6.385302E-04,-3.037535E-03,4.849529E-04,-8.358498E-04},
      EIRFunPLR =           {7.086284E-02,2.787561E-03,-8.917038E-06,2.309734E-01,1.250442E+00,-2.161029E-03,0.000000E+00,-5.630094E-01,0.000000E+00,0.000000E+00},
      etaMotor =            1.0)
    "ReformEIRChiller Trane CGWD 207kW/3.99COP/None" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:ReformulatedEIR,
    ReformEIRChiller Trane CGWD 207kW/3.99COP/None,  !- Name
    207400,                  !- Reference Capacity {W}
    3.99,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    35.00,                   !- Reference Leaving Condenser Water Temperature {C}
    0.00898,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01122,                 !- Reference Condenser Water Flow Rate {m3/s}
    ReformEIRChiller Trane CGWD 207kW/3.99COP/None CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ReformEIRChiller Trane CGWD 207kW/3.99COP/None EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ReformEIRChiller Trane CGWD 207kW/3.99COP/None EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.25,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.25,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode Type
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
</html>"));

annotation(preferredView="info",
 Documentation(info="<html>
<p>
Package with performance data for chillers.
</p>
</html>", revisions="<html>
<p>
Generated on 04/25/2016 13:20 by thierry
</p>
</html>"));
end ElectricReformulatedEIR;
