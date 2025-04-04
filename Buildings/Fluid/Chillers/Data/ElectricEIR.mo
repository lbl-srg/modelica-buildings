within Buildings.Fluid.Chillers.Data;
package ElectricEIR "Performance data for chiller ElectricEIR"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Generic data record for chiller ElectricEIR"
    extends Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
        final nCapFunT=6,
        final nEIRFunT=6,
        final nEIRFunPLR=3);
    parameter Modelica.Units.SI.Temperature TConEnt_nominal
      "Temperature of fluid entering condenser at nominal condition"
      annotation (Dialog(group="Nominal condition"));

    parameter Modelica.Units.SI.Temperature TConEntMin
      "Minimum value for entering condenser temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Modelica.Units.SI.Temperature TConEntMax
      "Maximum value for entering condenser temperature"
      annotation (Dialog(group="Performance curves"));

    annotation (
      defaultComponentName="datChi",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
<p>This record is used as a template for performance data
for the chiller model
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>.
To provide performance data for
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>, use
<a href=\"modelica://Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic\">
Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic</a> instead.
</p>
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

  record ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
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

  record ElectricEIRChiller_York_YT_563kW_10_61COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -562600,
      COP_nominal =         10.61,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.01514,
      mCon_flow_nominal =   1000 * 0.0241,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {-1.288612E-01,-8.919540E-02,-2.190195E-03,1.538357E-01,-5.129402E-03,7.813636E-03},
      EIRFunT =             {-5.781003E-01,-1.169130E-01,-4.760535E-03,2.230082E-01,-5.313649E-03,6.846644E-03},
      EIRFunPLR =           {5.203969E-01,-7.775900E-01,1.255394E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 563kW/10.61COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 563kW/10.61COP/Vanes,  !- Name
    562600,                  !- Reference Capacity {W}
    10.61,                   !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01514,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0241,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 563kW/10.61COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 563kW/10.61COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 563kW/10.61COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PEH_703kW_7_03COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -703300,
      COP_nominal =         7.03,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.02019,
      mCon_flow_nominal =   1000 * 0.02902,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {4.779439E-01,1.073486E-01,-1.055896E-02,4.208433E-02,-2.346870E-03,4.019632E-03},
      EIRFunT =             {8.234029E-01,-1.171542E-01,5.869351E-04,2.964642E-02,-9.190377E-04,5.035796E-03},
      EIRFunPLR =           {3.864389E-01,-2.522595E-01,8.672354E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 703kW/7.03COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 703kW/7.03COP/Vanes,  !- Name
    703300,                  !- Reference Capacity {W}
    7.03,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02019,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.02902,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 703kW/7.03COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 703kW/7.03COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 703kW/7.03COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_23XL_724kW_6_04COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -724400,
      COP_nominal =         6.04,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.01779,
      mCon_flow_nominal =   1000 * 0.01956,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 21.11,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 13.75,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {4.418712E-01,-8.384251E-02,-2.190707E-03,8.594633E-02,-3.322575E-03,6.652189E-03},
      EIRFunT =             {5.059102E-01,-1.621557E-02,3.346388E-04,2.350906E-02,3.514201E-04,-6.342981E-04},
      EIRFunPLR =           {1.879418E-01,3.562862E-01,4.540392E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 724kW/6.04COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 724kW/6.04COP/Vanes,  !- Name
    724400,                  !- Reference Capacity {W}
    6.04,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    21.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01779,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01956,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 724kW/6.04COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 724kW/6.04COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 724kW/6.04COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -742000,
      COP_nominal =         5.42,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.01779,
      mCon_flow_nominal =   1000 * 0.01956,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 21.11,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 11.25,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.797101E-01,-2.895701E-03,-8.970718E-04,1.031440E-02,-7.431651E-04,1.453508E-03},
      EIRFunT =             {9.946139E-01,-4.829399E-02,4.674277E-04,-1.158726E-03,5.762583E-04,2.148192E-04},
      EIRFunPLR =           {1.202277E-01,1.396384E-01,7.394038E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 742kW/5.42COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 742kW/5.42COP/VSD,  !- Name
    742000,                  !- Reference Capacity {W}
    5.42,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    21.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01779,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01956,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 742kW/5.42COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 742kW/5.42COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 742kW/5.42COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_WSC_816kW_6_74COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -815800,
      COP_nominal =         6.74,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.01748,
      mCon_flow_nominal =   1000 * 0.04164,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {9.862590E-01,5.799373E-02,-5.355626E-03,-8.941705E-04,-1.670098E-03,4.733054E-03},
      EIRFunT =             {7.335321E-01,4.465107E-04,-3.448575E-03,3.770822E-03,-2.189675E-04,2.400267E-03},
      EIRFunPLR =           {3.070136E-01,8.654874E-02,6.081551E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay WSC 816kW/6.74COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay WSC 816kW/6.74COP/Vanes,  !- Name
    815800,                  !- Reference Capacity {W}
    6.74,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01748,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04164,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay WSC 816kW/6.74COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 816kW/6.74COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 816kW/6.74COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PEH_819kW_8_11COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -819300,
      COP_nominal =         8.11,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.02524,
      mCon_flow_nominal =   1000 * 0.03785,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.392673E-01,4.328784E-02,-4.529446E-03,1.525410E-02,-1.141458E-03,2.651124E-03},
      EIRFunT =             {5.925176E-01,-1.908391E-02,-1.852692E-03,4.051551E-02,-2.908719E-04,1.059047E-03},
      EIRFunPLR =           {2.830681E-01,2.254147E-01,4.916649E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 819kW/8.11COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 819kW/8.11COP/Vanes,  !- Name
    819300,                  !- Reference Capacity {W}
    8.11,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02524,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03785,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 819kW/8.11COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 819kW/8.11COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 819kW/8.11COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_823kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -822900,
      COP_nominal =         6.28,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04744,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {5.573150E-01,8.714616E-02,-2.917582E-03,2.500000E-02,-8.861538E-04,-3.184615E-04},
      EIRFunT =             {8.029134E-01,2.171359E-02,2.388123E-04,-1.096173E-02,1.065277E-03,-2.057538E-03},
      EIRFunPLR =           {2.965419E-01,4.689744E-01,2.332341E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 823kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 823kW/6.28COP/Vanes,  !- Name
    822900,                  !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04744,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 823kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 823kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 823kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_869kW_5_57COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -868600,
      COP_nominal =         5.57,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.01754,
      mCon_flow_nominal =   1000 * 0.02593,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {5.406799E-01,1.253709E-01,-8.025360E-03,-7.357554E-03,-4.477789E-04,2.140733E-03},
      EIRFunT =             {3.943721E-01,1.079147E-01,-8.912223E-03,-3.229487E-04,1.302402E-05,1.561862E-03},
      EIRFunPLR =           {1.501042E-01,-6.804336E-02,9.171460E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 869kW/5.57COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 869kW/5.57COP/VSD,  !- Name
    868600,                  !- Reference Capacity {W}
    5.57,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01754,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.02593,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 869kW/5.57COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 869kW/5.57COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 869kW/5.57COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_897kW_7_23COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         7.23,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.0436,
      TEvaLvg_nominal =     273.15 + 9.82,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {5.559679E-01,7.630860E-02,-1.431181E-03,2.167593E-02,-6.233447E-04,-9.876498E-04},
      EIRFunT =             {6.511011E-01,4.948557E-02,-8.152733E-04,2.322946E-02,1.990802E-04,-2.669401E-03},
      EIRFunPLR =           {2.036380E-01,-3.913200E-01,1.187172E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 897kW/7.23COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 897kW/7.23COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    7.23,                    !- Reference COP {W/W}
    9.82,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0436,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 897kW/7.23COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 897kW/7.23COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 897kW/7.23COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_897kW_6_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         6.50,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04423,
      TEvaLvg_nominal =     273.15 + 9.82,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {7.009156E-01,2.151274E-02,-6.029650E-04,1.864266E-02,-1.084545E-03,1.418575E-03},
      EIRFunT =             {8.527749E-01,-4.336881E-03,8.972177E-04,-1.888039E-03,8.648075E-04,-1.438797E-03},
      EIRFunPLR =           {3.323416E-01,2.561103E-01,4.106954E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 897kW/6.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 897kW/6.50COP/Vanes,  !- Name
    896700,                  !- Reference Capacity {W}
    6.50,                    !- Reference COP {W/W}
    9.82,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04423,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 897kW/6.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 897kW/6.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 897kW/6.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_897kW_7_60COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         7.60,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 9.83,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {5.699948E-01,2.961470E-02,-1.064930E-03,3.062313E-02,-1.753205E-03,2.142105E-03},
      EIRFunT =             {5.526128E-01,3.299472E-03,-7.981925E-04,4.245710E-02,-3.533658E-04,-9.415137E-04},
      EIRFunPLR =           {4.708628E-02,7.070062E-02,8.802198E-01},
      etaMotor =            1.0) "ElectricEIRChiller York YT 897kW/7.60COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 897kW/7.60COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    7.60,                    !- Reference COP {W/W}
    9.83,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 897kW/7.60COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 897kW/7.60COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 897kW/7.60COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_897kW_6_27COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         6.27,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.197991E-01,1.568955E-01,-4.426242E-03,3.449640E-02,-8.163597E-04,-2.236230E-03},
      EIRFunT =             {5.530767E-01,-5.683068E-02,4.423475E-03,6.472411E-02,-7.378933E-04,-2.491202E-03},
      EIRFunPLR =           {9.836320E-02,-1.638320E-02,9.127289E-01},
      etaMotor =            1.0) "ElectricEIRChiller York YT 897kW/6.27COP/VSD"
    annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 897kW/6.27COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    6.27,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 897kW/6.27COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 897kW/6.27COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 897kW/6.27COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_897kW_6_23COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -896700,
      COP_nominal =         6.23,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04442,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {8.862185E-01,3.144947E-02,2.328997E-04,1.339712E-03,-2.923430E-04,2.320709E-04},
      EIRFunT =             {8.606461E-01,-1.202294E-03,9.398625E-04,2.983262E-03,4.119228E-04,-1.123884E-03},
      EIRFunPLR =           {2.075556E-01,-2.126466E-01,1.004182E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 897kW/6.23COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 897kW/6.23COP/VSD,  !- Name
    896700,                  !- Reference Capacity {W}
    6.23,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04442,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 897kW/6.23COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 897kW/6.23COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 897kW/6.23COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PFH_932kW_5_09COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -931900,
      COP_nominal =         5.09,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.182278E+00,3.259490E-02,-3.904288E-03,4.579721E-03,-1.028178E-03,2.855063E-03},
      EIRFunT =             {6.053491E-01,-1.089778E-02,-1.511327E-03,1.902687E-02,-1.910750E-04,9.008184E-04},
      EIRFunPLR =           {6.823245E-02,6.672421E-01,2.654211E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PFH 932kW/5.09COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PFH 932kW/5.09COP/Vanes,  !- Name
    931900,                  !- Reference Capacity {W}
    5.09,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PFH 932kW/5.09COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 932kW/5.09COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 932kW/5.09COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_960kW_4_64COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -960000,
      COP_nominal =         4.64,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.09,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {-2.278537E-01,4.055945E-01,-3.246694E-02,3.788230E-03,-2.236584E-04,6.715520E-04},
      EIRFunT =             {5.735924E-01,2.270414E-02,-3.331832E-03,6.025574E-03,3.245033E-04,3.229690E-05},
      EIRFunPLR =           {2.737941E-01,3.141127E-01,4.113671E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 960kW/4.64COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 960kW/4.64COP/Vanes,  !- Name
    960000,                  !- Reference Capacity {W}
    4.64,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 960kW/4.64COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 960kW/4.64COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 960kW/4.64COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.09,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1023kW_5_81COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1023300,
      COP_nominal =         5.81,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.02366,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {2.571195E-01,-1.571421E-02,-3.041761E-03,8.106512E-02,-2.568598E-03,4.247073E-03},
      EIRFunT =             {5.254964E-01,-1.972389E-02,3.441072E-04,1.651466E-02,2.005198E-04,-3.193246E-04},
      EIRFunPLR =           {2.368399E-01,3.286421E-01,4.344939E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1023kW/5.81COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1023kW/5.81COP/Vanes,  !- Name
    1023300,                 !- Reference Capacity {W}
    5.81,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02366,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1023kW/5.81COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1023kW/5.81COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1023kW/5.81COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PEH_1030kW_8_58COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1030300,
      COP_nominal =         8.58,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.02378,
      mCon_flow_nominal =   1000 * 0.03407,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {7.736028E-01,5.571395E-02,-3.058312E-03,-1.789007E-04,-9.808878E-04,2.123462E-03},
      EIRFunT =             {7.125878E-01,1.388940E-02,-2.473407E-03,2.096719E-02,-1.566098E-04,6.035460E-04},
      EIRFunPLR =           {3.215320E-01,-9.188416E-03,6.881582E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 1030kW/8.58COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 1030kW/8.58COP/Vanes,  !- Name
    1030300,                 !- Reference Capacity {W}
    8.58,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02378,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03407,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 1030kW/8.58COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1030kW/8.58COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1030kW/8.58COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1048kW_6_06COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1047900,
      COP_nominal =         6.06,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.04542,
      mCon_flow_nominal =   1000 * 0.05678,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {7.238221E-01,1.747548E-02,-4.524718E-03,2.138468E-02,-9.342801E-04,2.515069E-03},
      EIRFunT =             {7.255594E-01,-3.502968E-02,2.213476E-03,3.925410E-03,5.538176E-04,-8.638012E-04},
      EIRFunPLR =           {1.543796E-01,7.276121E-01,1.162393E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1048kW/6.06COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1048kW/6.06COP/Vanes,  !- Name
    1047900,                 !- Reference Capacity {W}
    6.06,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04542,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05678,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1048kW/6.06COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1048kW/6.06COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1048kW/6.06COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1055000,
      COP_nominal =         5.96,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.02839,
      mCon_flow_nominal =   1000 * 0.05678,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {1.785912E-01,-5.900023E-02,-5.946963E-04,9.297889E-02,-2.841024E-03,4.974221E-03},
      EIRFunT =             {5.245110E-01,-2.850126E-02,8.034720E-04,1.893133E-02,1.151629E-04,-9.340642E-05},
      EIRFunPLR =           {2.619878E-01,2.393605E-01,4.988306E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1055kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1055kW/5.96COP/Vanes,  !- Name
    1055000,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02839,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05678,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1055kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1055kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1055kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1076kW_5_52COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1076100,
      COP_nominal =         5.52,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04744,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.89,
      capFunT =             {9.187704E-01,4.509452E-02,-5.119187E-03,-2.095629E-04,-6.432511E-04,2.791545E-03},
      EIRFunT =             {7.511044E-01,2.415573E-02,-5.310959E-03,-1.073812E-03,1.189538E-04,1.604476E-03},
      EIRFunPLR =           {1.315760E-01,-3.004087E-02,8.967180E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes,  !- Name
    1076100,                 !- Reference Capacity {W}
    5.52,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04744,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1080kW_7_39COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1079600,
      COP_nominal =         7.39,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.06416,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.61,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 16.24,
      TConEntMax =          273.15 + 23.61,
      capFunT =             {4.365583E-01,-3.677215E-02,-2.779781E-03,6.063060E-02,-2.290704E-03,5.115883E-03},
      EIRFunT =             {3.608716E-01,-5.637178E-02,-3.428415E-04,4.230087E-02,-4.391632E-04,1.517182E-03},
      EIRFunPLR =           {1.789841E-01,2.976513E-01,5.243235E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1080kW/7.39COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1080kW/7.39COP/Vanes,  !- Name
    1079600,                 !- Reference Capacity {W}
    7.39,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.61,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06416,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1080kW/7.39COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1080kW/7.39COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1080kW/7.39COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1090kW_7_57COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1090100,
      COP_nominal =         7.57,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {6.769028E-01,5.711844E-02,-6.072310E-04,1.656541E-02,-8.087831E-04,2.303904E-04},
      EIRFunT =             {9.241019E-01,-4.961574E-02,1.291675E-04,3.299013E-02,-6.769477E-04,1.692815E-03},
      EIRFunPLR =           {1.431969E-01,-4.920686E-01,1.341333E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1090kW/7.57COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1090kW/7.57COP/VSD,  !- Name
    1090100,                 !- Reference Capacity {W}
    7.57,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1090kW/7.57COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1090kW/7.57COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1090kW/7.57COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PEH_1104kW_8_00COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1104200,
      COP_nominal =         8.00,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.02423,
      mCon_flow_nominal =   1000 * 0.03028,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {8.210185E-01,4.386152E-02,-1.521829E-03,-4.314921E-03,-7.251667E-04,1.497681E-03},
      EIRFunT =             {8.655242E-01,-3.808337E-04,-1.320050E-03,1.137834E-02,-4.095120E-05,6.531102E-04},
      EIRFunPLR =           {3.091150E-01,-1.089639E-02,7.022967E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 1104kW/8.00COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 1104kW/8.00COP/Vanes,  !- Name
    1104200,                 !- Reference Capacity {W}
    8.00,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02423,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03028,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 1104kW/8.00COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1104kW/8.00COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1104kW/8.00COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1125kW_4_89COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1125300,
      COP_nominal =         4.89,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.02776,
      mCon_flow_nominal =   1000 * 0.02618,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {6.151549E-01,-1.181250E-02,-1.491630E-03,3.326625E-02,-9.315000E-04,1.771875E-03},
      EIRFunT =             {5.810580E-01,-4.344257E-02,-5.369108E-04,2.844405E-02,-1.609390E-04,7.004346E-04},
      EIRFunPLR =           {1.807198E-01,-1.469686E-01,9.658417E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1125kW/4.89COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1125kW/4.89COP/Vanes,  !- Name
    1125300,                 !- Reference Capacity {W}
    4.89,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02776,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.02618,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1125kW/4.89COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1125kW/4.89COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1125kW/4.89COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_1125kW_7_92COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1125300,
      COP_nominal =         7.92,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03243,
      mCon_flow_nominal =   1000 * 0.05173,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.034212E-01,2.327078E-03,-9.117035E-04,9.104793E-02,-2.678967E-03,2.274649E-03},
      EIRFunT =             {6.542286E-01,-2.451604E-02,1.253508E-03,4.216477E-02,1.404867E-04,-1.508780E-03},
      EIRFunPLR =           {1.147453E-01,4.231235E-02,8.419681E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1125kW/7.92COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1125kW/7.92COP/VSD,  !- Name
    1125300,                 !- Reference Capacity {W}
    7.92,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03243,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05173,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1125kW/7.92COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1125kW/7.92COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1125kW/7.92COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1129kW_7_19COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1128800,
      COP_nominal =         7.19,
      PLRMin =              0.15,
      PLRMinUnl =           0.15,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.02776,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {3.922479E-01,-4.388411E-02,-2.748665E-03,6.894954E-02,-2.563738E-03,5.420187E-03},
      EIRFunT =             {3.742142E-01,-5.536709E-02,-8.199663E-04,4.655032E-02,-7.312591E-04,1.887184E-03},
      EIRFunPLR =           {1.693841E-01,2.475201E-01,5.836059E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1129kW/7.19COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1129kW/7.19COP/Vanes,  !- Name
    1128800,                 !- Reference Capacity {W}
    7.19,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02776,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1129kW/7.19COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1129kW/7.19COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1129kW/7.19COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.15,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.15,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1143kW_6_57COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1142900,
      COP_nominal =         6.57,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.02593,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 10.00,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {7.939538E-01,4.096493E-02,-1.419397E-03,-1.639813E-03,-5.220497E-04,1.348786E-03},
      EIRFunT =             {9.475580E-01,-1.187942E-02,8.799326E-05,2.250775E-04,1.815775E-04,2.178409E-04},
      EIRFunPLR =           {1.408822E-01,-1.578153E-01,1.014316E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1143kW/6.57COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1143kW/6.57COP/VSD,  !- Name
    1142900,                 !- Reference Capacity {W}
    6.57,                    !- Reference COP {W/W}
    10.00,                   !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02593,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1143kW/6.57COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1143kW/6.57COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1143kW/6.57COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1157kW_5_62COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1156900,
      COP_nominal =         5.62,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.02801,
      mCon_flow_nominal =   1000 * 0.03186,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 21.11,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 11.25,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.076248E+00,5.436724E-03,-3.893302E-04,-4.353310E-03,-2.402031E-04,8.409080E-04},
      EIRFunT =             {1.075567E+00,-3.893571E-02,1.082499E-03,-5.782829E-03,6.574492E-04,-5.302886E-04},
      EIRFunPLR =           {1.608589E-01,-2.058215E-01,1.043133E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1157kW/5.62COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1157kW/5.62COP/VSD,  !- Name
    1156900,                 !- Reference Capacity {W}
    5.62,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    21.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02801,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03186,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1157kW/5.62COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1157kW/5.62COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1157kW/5.62COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1196kW_6_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1195600,
      COP_nominal =         6.50,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03426,
      mCon_flow_nominal =   1000 * 0.04252,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.126801E+00,-4.220591E-03,-2.002964E-03,7.360880E-03,-1.156890E-03,3.064875E-03},
      EIRFunT =             {9.514432E-01,-2.252147E-02,-1.062456E-05,-1.383194E-04,3.914644E-04,8.126485E-05},
      EIRFunPLR =           {2.724491E-01,2.710369E-01,4.552356E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes,  !- Name
    1195600,                 !- Reference Capacity {W}
    6.50,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03426,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04252,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1196kW/6.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1213kW_7_78COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1213200,
      COP_nominal =         7.78,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03243,
      mCon_flow_nominal =   1000 * 0.04782,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.070437E-01,-7.437456E-03,-9.695325E-04,1.529092E-02,-1.069664E-03,1.994583E-03},
      EIRFunT =             {1.002142E+00,-2.505239E-02,5.169707E-04,6.321862E-03,5.116807E-04,-4.794244E-04},
      EIRFunPLR =           {2.847744E-01,4.027863E-01,3.114896E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes,  !- Name
    1213200,                 !- Reference Capacity {W}
    7.78,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03243,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04782,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1213kW/7.78COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PEH_1231kW_6_18COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1230800,
      COP_nominal =         6.18,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03533,
      mCon_flow_nominal =   1000 * 0.0511,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.152795E+00,9.770474E-02,-6.719705E-03,-2.123401E-02,-3.641998E-04,1.473439E-03},
      EIRFunT =             {8.067591E-01,1.868314E-02,-5.569088E-03,-4.309148E-03,1.373034E-04,2.394081E-03},
      EIRFunPLR =           {2.117054E-01,4.263662E-01,3.614654E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 1231kW/6.18COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 1231kW/6.18COP/Vanes,  !- Name
    1230800,                 !- Reference Capacity {W}
    6.18,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03533,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0511,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 1231kW/6.18COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1231kW/6.18COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1231kW/6.18COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1234kW_5_39COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1234300,
      COP_nominal =         5.39,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.02593,
      mCon_flow_nominal =   1000 * 0.03861,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {5.905815E-01,1.190927E-01,-6.727309E-03,-9.580836E-03,-3.034704E-04,1.540686E-03},
      EIRFunT =             {3.771659E-01,1.144965E-01,-8.186893E-03,-3.372584E-03,1.689440E-04,1.008523E-03},
      EIRFunPLR =           {1.495681E-01,-1.449639E-01,9.941070E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1234kW/5.39COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1234kW/5.39COP/VSD,  !- Name
    1234300,                 !- Reference Capacity {W}
    5.39,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02593,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03861,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1234kW/5.39COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1234kW/5.39COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1234kW/5.39COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1259kW_6_26COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1258900,
      COP_nominal =         6.26,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.02593,
      mCon_flow_nominal =   1000 * 0.03823,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {1.082071E+00,3.200888E-02,-3.994780E-03,-5.789604E-03,-8.238938E-04,2.933539E-03},
      EIRFunT =             {7.582035E-01,6.896017E-03,-1.491911E-03,2.249459E-03,3.908697E-04,-1.735265E-04},
      EIRFunPLR =           {2.226232E-01,5.199282E-01,2.578470E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes,  !- Name
    1258900,                 !- Reference Capacity {W}
    6.26,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02593,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03823,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1259kW/6.26COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_1259kW_6_45COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1258900,
      COP_nominal =         6.45,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.02631,
      mCon_flow_nominal =   1000 * 0.06246,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {9.609200E-01,7.223733E-02,-1.693471E-03,2.543722E-03,-6.415570E-04,-3.028540E-04},
      EIRFunT =             {8.991536E-01,6.305932E-03,-3.756374E-04,-1.952076E-02,1.381302E-03,-1.615004E-03},
      EIRFunPLR =           {1.014593E-01,6.216537E-01,2.780213E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 1259kW/6.45COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 1259kW/6.45COP/Vanes,  !- Name
    1258900,                 !- Reference Capacity {W}
    6.45,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.02631,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06246,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 1259kW/6.45COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 1259kW/6.45COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 1259kW/6.45COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1266kW_4_39COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1266000,
      COP_nominal =         4.39,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.03533,
      mCon_flow_nominal =   1000 * 0.05773,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 35.00,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {1.285663E-01,-2.860032E-02,-1.369319E-03,6.676366E-02,-1.510647E-03,2.947167E-03},
      EIRFunT =             {8.284925E-02,4.206167E-02,-5.254555E-03,1.964407E-02,1.070646E-04,2.298241E-04},
      EIRFunPLR =           {7.326942E-01,-7.962527E-01,1.059148E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1266kW/4.39COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1266kW/4.39COP/Vanes,  !- Name
    1266000,                 !- Reference Capacity {W}
    4.39,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    35.00,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03533,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05773,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1266kW/4.39COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1266kW/4.39COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1266kW/4.39COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1284kW_6_20COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1283500,
      COP_nominal =         6.20,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03684,
      mCon_flow_nominal =   1000 * 0.05337,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.119245E+00,-1.524417E-02,-1.074186E-03,-1.260169E-03,-4.380237E-04,2.027779E-03},
      EIRFunT =             {7.815645E-01,-2.448971E-02,1.644370E-03,5.564580E-03,5.800428E-04,-1.086993E-03},
      EIRFunPLR =           {2.324812E-01,7.690691E-01,-6.532223E-04},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes,  !- Name
    1283500,                 !- Reference Capacity {W}
    6.20,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03684,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1284kW/6.20COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1294kW_7_61COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1294100,
      COP_nominal =         7.61,
      PLRMin =              0.16,
      PLRMinUnl =           0.16,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03243,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.274222E-01,1.278683E-02,-1.621880E-03,2.816339E-03,-7.658105E-04,1.881968E-03},
      EIRFunT =             {1.085249E+00,-9.441252E-04,-2.505100E-03,-8.724367E-03,4.164780E-04,8.473746E-04},
      EIRFunPLR =           {9.344563E-02,3.993002E-01,5.087169E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes,  !- Name
    1294100,                 !- Reference Capacity {W}
    7.61,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03243,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1294kW/7.61COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.16,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.16,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1329kW_5_38COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1329300,
      COP_nominal =         5.38,
      PLRMin =              0.29,
      PLRMinUnl =           0.29,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.04732,
      mCon_flow_nominal =   1000 * 0.07098,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 21.11,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.339754E-01,1.016009E-01,-3.979592E-03,1.261254E-02,-4.666667E-04,-8.351648E-05},
      EIRFunT =             {8.074052E-01,3.355495E-02,-1.549617E-03,-7.142554E-03,5.056363E-04,-7.547786E-04},
      EIRFunPLR =           {4.079777E-02,1.174456E+00,-2.212711E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1329kW/5.38COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1329kW/5.38COP/Vanes,  !- Name
    1329300,                 !- Reference Capacity {W}
    5.38,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04732,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07098,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1329kW/5.38COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1329kW/5.38COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1329kW/5.38COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.29,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.29,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1350kW_7_90COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1350400,
      COP_nominal =         7.90,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03684,
      mCon_flow_nominal =   1000 * 0.05337,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.063866E+00,-1.448990E-02,-1.021036E-03,-1.197817E-03,-4.163507E-04,1.927446E-03},
      EIRFunT =             {9.953536E-01,-3.118863E-02,2.094171E-03,7.086716E-03,7.387078E-04,-1.384330E-03},
      EIRFunPLR =           {3.336374E-01,-4.098166E-01,1.077791E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1350kW/7.90COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1350kW/7.90COP/VSD,  !- Name
    1350400,                 !- Reference Capacity {W}
    7.90,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03684,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1350kW/7.90COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1350kW/7.90COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1350kW/7.90COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1368kW_7_35COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1367900,
      COP_nominal =         7.35,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {3.832184E-01,-3.265439E-02,-3.392654E-03,8.580180E-02,-3.513013E-03,6.528440E-03},
      EIRFunT =             {3.227543E-01,-1.415418E-02,-5.090650E-03,4.606511E-02,-8.769578E-04,2.600343E-03},
      EIRFunPLR =           {9.483562E-02,1.521114E-01,7.543027E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1368kW/7.35COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1368kW/7.35COP/VSD,  !- Name
    1367900,                 !- Reference Capacity {W}
    7.35,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1368kW/7.35COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1368kW/7.35COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1368kW/7.35COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1372kW_7_49COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1371500,
      COP_nominal =         7.49,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.993784E-01,6.523380E-02,-7.714286E-03,3.114955E-02,-1.843989E-03,4.096552E-03},
      EIRFunT =             {9.123765E-01,1.616509E-02,1.906349E-03,-1.143164E-02,1.080775E-03,-2.873661E-03},
      EIRFunPLR =           {5.154478E-02,9.635713E-01,-1.896824E-02},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1372kW/7.49COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1372kW/7.49COP/Vanes,  !- Name
    1371500,                 !- Reference Capacity {W}
    7.49,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1372kW/7.49COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1372kW/7.49COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1372kW/7.49COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1396kW_7_35COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1396100,
      COP_nominal =         7.35,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.167863E-01,-2.788454E-02,-9.497810E-04,6.693411E-02,-2.728430E-03,4.723123E-03},
      EIRFunT =             {5.207500E-01,-9.073869E-03,-1.812171E-04,2.568740E-02,4.255936E-05,-5.899242E-04},
      EIRFunPLR =           {3.043032E-01,3.720107E-02,6.590338E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1396kW/7.35COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1396kW/7.35COP/Vanes,  !- Name
    1396100,                 !- Reference Capacity {W}
    7.35,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1396kW/7.35COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1396kW/7.35COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1396kW/7.35COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1403kW_7_09COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1403100,
      COP_nominal =         7.09,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03426,
      mCon_flow_nominal =   1000 * 0.04252,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.601814E-01,-3.596494E-03,-1.706786E-03,6.272429E-03,-9.858212E-04,2.611673E-03},
      EIRFunT =             {1.098641E+00,-2.485880E-02,-6.240421E-05,-1.719488E-03,4.887321E-04,9.618075E-05},
      EIRFunPLR =           {8.788698E-02,2.678891E-01,6.445180E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1403kW/7.09COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1403kW/7.09COP/VSD,  !- Name
    1403100,                 !- Reference Capacity {W}
    7.09,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03426,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04252,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1403kW/7.09COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1403kW/7.09COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1403kW/7.09COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1403kW_6_94COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1403100,
      COP_nominal =         6.94,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.1,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.05047,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {-3.447077E-02,1.273138E-01,-9.716868E-03,8.863546E-02,-3.165958E-03,2.521351E-03},
      EIRFunT =             {3.983846E-01,2.396665E-02,-6.601871E-03,2.944077E-02,-4.570885E-04,1.873209E-03},
      EIRFunPLR =           {3.272242E-02,3.873540E-01,5.789579E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1403kW/6.94COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1403kW/6.94COP/VSD,  !- Name
    1403100,                 !- Reference Capacity {W}
    6.94,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05047,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1403kW/6.94COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1403kW/6.94COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1403kW/6.94COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.1,                     !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1407kW_7_14COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1406600,
      COP_nominal =         7.14,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {4.521342E-01,5.248142E-03,-6.687636E-03,5.869437E-02,-2.390647E-03,5.040171E-03},
      EIRFunT =             {5.674858E-01,4.461513E-02,-6.341978E-03,4.674972E-03,4.387295E-04,2.778096E-04},
      EIRFunPLR =           {5.963988E-02,3.503067E-01,5.870000E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1407kW/7.14COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1407kW/7.14COP/VSD,  !- Name
    1406600,                 !- Reference Capacity {W}
    7.14,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1407kW/7.14COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1407kW/7.14COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1407kW/7.14COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PFH_1407kW_6_60COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1406600,
      COP_nominal =         6.60,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.04038,
      mCon_flow_nominal =   1000 * 0.05804,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.191784E+00,2.070584E-02,-4.952378E-03,1.757508E-02,-2.487599E-03,5.934709E-03},
      EIRFunT =             {7.929709E-01,3.424884E-02,-5.567434E-03,-6.974667E-03,2.531138E-04,1.862577E-03},
      EIRFunPLR =           {7.700603E-02,5.414789E-01,3.826334E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PFH 1407kW/6.60COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PFH 1407kW/6.60COP/Vanes,  !- Name
    1406600,                 !- Reference Capacity {W}
    6.60,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04038,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05804,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PFH 1407kW/6.60COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 1407kW/6.60COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 1407kW/6.60COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1407kW_6_04COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1406600,
      COP_nominal =         6.04,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06057,
      mCon_flow_nominal =   1000 * 0.07571,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 32.22,
      capFunT =             {1.042261E+00,2.644821E-03,-1.468026E-03,1.366256E-02,-8.302334E-04,1.573579E-03},
      EIRFunT =             {1.026340E+00,-1.612819E-02,-1.092591E-03,-1.784393E-02,7.961842E-04,-9.586049E-05},
      EIRFunPLR =           {1.188880E-01,6.723542E-01,2.068754E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1407kW/6.04COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1407kW/6.04COP/VSD,  !- Name
    1406600,                 !- Reference Capacity {W}
    6.04,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06057,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07571,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1407kW/6.04COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1407kW/6.04COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1407kW/6.04COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1410kW_8_54COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1410100,
      COP_nominal =         8.54,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04,
      mCon_flow_nominal =   1000 * 0.05861,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.597856E-01,-6.247187E-03,-1.117998E-03,6.991040E-03,-6.321252E-04,1.765068E-03},
      EIRFunT =             {1.131014E+00,-6.735406E-02,3.034309E-06,1.307361E-02,3.384625E-04,7.872113E-04},
      EIRFunPLR =           {9.662908E-02,7.475978E-01,1.566368E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1410kW/8.54COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1410kW/8.54COP/VSD,  !- Name
    1410100,                 !- Reference Capacity {W}
    8.54,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04,                    !- Reference Chilled Water Flow Rate {m3/s}
    0.05861,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1410kW/8.54COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1410kW/8.54COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1410kW/8.54COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1441800,
      COP_nominal =         6.61,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.05047,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {4.007341E-01,1.148568E-03,1.049504E-04,5.574667E-02,-1.646131E-03,1.323200E-03},
      EIRFunT =             {6.287646E-01,-3.024605E-02,6.137016E-04,1.805826E-02,1.640653E-04,-1.113802E-04},
      EIRFunPLR =           {9.299787E-02,3.244475E-01,5.818753E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1442kW/6.61COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1442kW/6.61COP/VSD,  !- Name
    1441800,                 !- Reference Capacity {W}
    6.61,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05047,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1442kW/6.61COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1442kW/6.61COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1442kW/6.61COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_1459kW_6_40COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1459400,
      COP_nominal =         6.40,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.13,
      mEva_flow_nominal =   1000 * 0.05047,
      mCon_flow_nominal =   1000 * 0.05047,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {-1.665585E-01,2.211580E-01,-1.408361E-02,6.476151E-02,-2.009341E-03,-7.897630E-05},
      EIRFunT =             {1.438935E-01,9.821191E-02,-1.174270E-02,3.748666E-02,-5.700518E-04,1.053698E-03},
      EIRFunPLR =           {3.999642E-02,2.509430E-01,7.067059E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1459kW/6.40COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1459kW/6.40COP/VSD,  !- Name
    1459400,                 !- Reference Capacity {W}
    6.40,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05047,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05047,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1459kW/6.40COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1459kW/6.40COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1459kW/6.40COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.13,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1484kW_9_96COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1484000,
      COP_nominal =         9.96,
      PLRMin =              0.24,
      PLRMinUnl =           0.24,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {-4.544480E-01,-3.615933E-02,-2.734006E-03,1.683863E-01,-4.557649E-03,5.362840E-03},
      EIRFunT =             {-3.693940E-01,-6.387787E-02,-2.760494E-04,1.661135E-01,-3.105485E-03,1.705909E-03},
      EIRFunPLR =           {1.353827E-01,1.385983E-02,8.522688E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1484kW/9.96COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1484kW/9.96COP/VSD,  !- Name
    1484000,                 !- Reference Capacity {W}
    9.96,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1484kW/9.96COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1484kW/9.96COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1484kW/9.96COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.24,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.24,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1495kW_7_51COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1494500,
      COP_nominal =         7.51,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.0429,
      mCon_flow_nominal =   1000 * 0.06719,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {1.051921E+00,-1.632255E-01,1.149042E-02,5.463515E-02,-1.579985E-03,1.628246E-03},
      EIRFunT =             {7.106985E-01,-2.087623E-01,9.421379E-03,8.491925E-02,-1.260820E-03,1.125512E-03},
      EIRFunPLR =           {1.517470E-01,-1.577252E-01,1.005197E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1495kW/7.51COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1495kW/7.51COP/VSD,  !- Name
    1494500,                 !- Reference Capacity {W}
    7.51,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.0429,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.06719,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1495kW/7.51COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1495kW/7.51COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1495kW/7.51COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_WSC_1519kW_7_10COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1519200,
      COP_nominal =         7.10,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.08139,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {1.265889E+00,3.401563E-02,-6.532621E-03,-6.600960E-03,-2.172017E-03,7.121766E-03},
      EIRFunT =             {9.981236E-01,-1.060763E-02,-3.921458E-03,-1.206761E-02,-1.398595E-04,3.467199E-03},
      EIRFunPLR =           {1.563837E-01,4.894381E-01,3.541551E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay WSC 1519kW/7.10COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay WSC 1519kW/7.10COP/Vanes,  !- Name
    1519200,                 !- Reference Capacity {W}
    7.10,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.08139,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay WSC 1519kW/7.10COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 1519kW/7.10COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 1519kW/7.10COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1558kW_5_81COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1557800,
      COP_nominal =         5.81,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 21.11,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 11.94,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.034307E+00,2.390635E-02,-1.222578E-03,-5.346220E-03,-2.183258E-04,6.282331E-04},
      EIRFunT =             {1.099343E+00,-3.132676E-02,4.108521E-04,-7.377845E-03,5.775048E-04,-3.528472E-04},
      EIRFunPLR =           {1.620909E-01,-2.553890E-01,1.092232E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1558kW/5.81COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1558kW/5.81COP/VSD,  !- Name
    1557800,                 !- Reference Capacity {W}
    5.81,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    21.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1558kW/5.81COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1558kW/5.81COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1558kW/5.81COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1586kW_5_53COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1586000,
      COP_nominal =         5.53,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03388,
      mCon_flow_nominal =   1000 * 0.04669,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {1.119233E+00,1.130501E-02,-6.423802E-04,-5.144512E-03,-3.085995E-04,7.813582E-04},
      EIRFunT =             {1.110611E+00,-3.795765E-02,2.851444E-04,-4.560404E-03,4.044229E-04,1.407332E-04},
      EIRFunPLR =           {1.996379E-01,-1.612021E-01,9.608483E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1586kW/5.53COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1586kW/5.53COP/VSD,  !- Name
    1586000,                 !- Reference Capacity {W}
    5.53,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03388,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04669,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1586kW/5.53COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1586kW/5.53COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1586kW/5.53COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PEH_1635kW_7_47COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1635200,
      COP_nominal =         7.47,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04416,
      mCon_flow_nominal =   1000 * 0.06624,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {9.894188E-01,2.983148E-03,-2.484601E-03,5.974984E-03,-1.063988E-03,2.601503E-03},
      EIRFunT =             {1.040733E+00,-7.118888E-02,2.262395E-03,1.221901E-02,2.152693E-04,7.409943E-04},
      EIRFunPLR =           {1.836695E-01,5.781685E-01,2.385719E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 1635kW/7.47COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 1635kW/7.47COP/Vanes,  !- Name
    1635200,                 !- Reference Capacity {W}
    7.47,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04416,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06624,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 1635kW/7.47COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1635kW/7.47COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1635kW/7.47COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1635kW_6_36COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1635200,
      COP_nominal =         6.36,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.03432,
      mCon_flow_nominal =   1000 * 0.05035,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {7.639212E-01,1.160405E-02,-5.344185E-03,3.306796E-02,-2.100827E-03,4.920586E-03},
      EIRFunT =             {7.355981E-01,-1.083354E-02,-9.244662E-04,1.458943E-02,8.494647E-06,1.279572E-04},
      EIRFunPLR =           {2.581595E-01,2.707154E-01,4.707425E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes,  !- Name
    1635200,                 !- Reference Capacity {W}
    6.36,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03432,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05035,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1635kW/6.36COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1656kW_8_24COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1656300,
      COP_nominal =         8.24,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.04322,
      mCon_flow_nominal =   1000 * 0.06296,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {7.611706E-01,-2.867067E-02,-2.363358E-03,4.097113E-02,-2.343044E-03,4.547017E-03},
      EIRFunT =             {7.730916E-01,-8.073559E-02,-2.161313E-03,6.144398E-02,-1.953734E-03,4.056527E-03},
      EIRFunPLR =           {1.982584E-01,4.414042E-02,7.642946E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1656kW/8.24COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1656kW/8.24COP/VSD,  !- Name
    1656300,                 !- Reference Capacity {W}
    8.24,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04322,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06296,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1656kW/8.24COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1656kW/8.24COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1656kW/8.24COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1663kW_9_34COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1663300,
      COP_nominal =         9.34,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04139,
      mCon_flow_nominal =   1000 * 0.0776,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {9.112226E-01,-4.546497E-02,4.431126E-03,2.439160E-02,-1.415836E-03,1.877877E-03},
      EIRFunT =             {1.028094E+00,-6.127553E-02,3.236371E-03,1.656482E-02,2.976850E-04,-4.418361E-04},
      EIRFunPLR =           {2.127966E-01,3.131004E-01,4.726018E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1663kW/9.34COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1663kW/9.34COP/Vanes,  !- Name
    1663300,                 !- Reference Capacity {W}
    9.34,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04139,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0776,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1663kW/9.34COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1663kW/9.34COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1663kW/9.34COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
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
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
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

  record ElectricEIRChiller_Trane_CVHF_1681kW_6_59COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1680900,
      COP_nominal =         6.59,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.04366,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 18.33,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {6.792987E-01,-5.291217E-02,-5.280108E-03,5.252682E-02,-2.523689E-03,7.344940E-03},
      EIRFunT =             {4.344630E-01,-5.781149E-03,2.852311E-04,2.723246E-02,1.280801E-04,-8.964328E-04},
      EIRFunPLR =           {1.619116E-01,2.362420E-01,6.032459E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 1681kW/6.59COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 1681kW/6.59COP/Vanes,  !- Name
    1680900,                 !- Reference Capacity {W}
    6.59,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04366,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 1681kW/6.59COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1681kW/6.59COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1681kW/6.59COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1723kW_8_32COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1723100,
      COP_nominal =         8.32,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.04757,
      mCon_flow_nominal =   1000 * 0.06934,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {4.742518E-01,-5.109937E-02,-2.845323E-03,8.257997E-02,-3.404799E-03,5.625321E-03},
      EIRFunT =             {2.950574E-01,-1.036684E-01,-4.169567E-03,1.256790E-01,-4.004203E-03,6.718687E-03},
      EIRFunPLR =           {2.374010E-01,-1.796745E-01,9.441507E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1723kW/8.32COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1723kW/8.32COP/VSD,  !- Name
    1723100,                 !- Reference Capacity {W}
    8.32,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04757,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06934,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1723kW/8.32COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1723kW/8.32COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1723kW/8.32COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1727kW_9_04COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1726600,
      COP_nominal =         9.04,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03912,
      mCon_flow_nominal =   1000 * 0.07192,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {6.509915E-01,2.567642E-02,-5.417815E-03,3.406103E-02,-1.703640E-03,3.336164E-03},
      EIRFunT =             {1.072553E+00,-8.058631E-03,-2.109608E-03,-1.262910E-03,6.155442E-04,4.796754E-04},
      EIRFunPLR =           {2.465824E-01,4.494453E-01,3.037680E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes,  !- Name
    1726600,                 !- Reference Capacity {W}
    9.04,                    !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03912,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07192,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1727kW/9.04COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_WSC_1751kW_6_73COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1751300,
      COP_nominal =         6.73,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.04145,
      mCon_flow_nominal =   1000 * 0.09337,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {7.923045E-01,1.003672E-01,-4.348900E-03,3.755572E-03,-7.675491E-04,6.788600E-04},
      EIRFunT =             {8.089395E-01,2.628482E-02,-1.773497E-03,-8.118430E-03,7.146809E-04,-6.481705E-04},
      EIRFunPLR =           {2.250725E-01,2.648297E-01,5.095786E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay WSC 1751kW/6.73COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay WSC 1751kW/6.73COP/Vanes,  !- Name
    1751300,                 !- Reference Capacity {W}
    6.73,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04145,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay WSC 1751kW/6.73COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 1751kW/6.73COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay WSC 1751kW/6.73COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_CVHF_1758kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.96,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.44,
      capFunT =             {1.074211E+00,7.710761E-03,-3.166770E-03,-1.868765E-02,1.273866E-04,2.744586E-03},
      EIRFunT =             {4.910329E-01,-9.895115E-02,4.257871E-03,5.433817E-02,-8.184909E-04,6.178810E-04},
      EIRFunPLR =           {3.694797E-01,9.551656E-02,5.347291E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 1758kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 1758kW/5.96COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 1758kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1758kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1758kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1758kW_5_76COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.76,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.51,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.44,
      capFunT =             {4.575085E-01,1.313508E-01,-4.408831E-03,1.930354E-02,-5.479641E-04,-1.376580E-03},
      EIRFunT =             {6.794525E-01,6.694756E-02,-3.625396E-03,-1.018762E-02,1.066394E-03,-2.113402E-03},
      EIRFunPLR =           {7.859908E-02,1.950291E-01,7.241581E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1758kW/5.76COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1758kW/5.76COP/VSD,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.76,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1758kW/5.76COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/5.76COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/5.76COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_1758kW_6_26COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.26,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.14,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.44,
      capFunT =             {8.975936E-01,-1.459740E-02,3.647187E-03,3.202545E-02,-1.190379E-03,3.297810E-04},
      EIRFunT =             {2.311197E-01,9.581517E-02,-5.672726E-03,2.766035E-02,-1.411214E-04,-1.011216E-03},
      EIRFunPLR =           {1.720545E-01,5.598164E-01,2.626117E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1758kW/6.26COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1758kW/6.26COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.26,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1758kW/6.26COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/6.26COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/6.26COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.14,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_1758kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.96,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.44,
      capFunT =             {8.492365E-01,5.551947E-02,-2.973138E-04,1.164389E-03,-2.955716E-04,8.464931E-05},
      EIRFunT =             {4.949320E-01,9.099785E-03,-6.935841E-04,3.277452E-02,-3.895481E-04,-5.524011E-04},
      EIRFunPLR =           {2.236154E-01,2.590053E-01,5.169137E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1758kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1758kW/5.96COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1758kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_CVHE_1758kW_5_96COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.96,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 23.89,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {9.566057E-02,-2.457943E-02,-6.827143E-03,7.119360E-02,-2.047680E-03,5.248800E-03},
      EIRFunT =             {1.243313E+00,-3.031784E-02,3.452464E-03,-2.739941E-02,9.141695E-04,-1.000080E-03},
      EIRFunPLR =           {1.871377E-01,5.849639E-01,2.291447E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHE 1758kW/5.96COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHE 1758kW/5.96COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.96,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHE 1758kW/5.96COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1758kW/5.96COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHE 1758kW/5.96COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1758kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.28,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {7.079149E-01,-2.006276E-03,-2.596043E-03,3.005922E-02,-1.056423E-03,2.045705E-03},
      EIRFunT =             {5.605391E-01,-1.377994E-02,6.569542E-05,1.321951E-02,2.686074E-04,-5.011451E-04},
      EIRFunPLR =           {1.861223E-01,5.482049E-01,2.647377E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1758kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1758kW/6.28COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1758kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1758kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1758kW_5_86COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.86,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06303,
      mCon_flow_nominal =   1000 * 0.07337,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.44,
      capFunT =             {3.677279E-01,-3.175504E-02,-4.096383E-03,7.527566E-02,-2.757540E-03,5.359020E-03},
      EIRFunT =             {1.743365E-01,-5.054806E-02,-5.424748E-03,8.244673E-02,-2.400392E-03,5.078720E-03},
      EIRFunPLR =           {2.784580E-01,-5.498632E-01,1.269693E+00},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1758kW/5.86COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1758kW/5.86COP/VSD,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.86,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06303,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1758kW/5.86COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1758kW/5.86COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1758kW/5.86COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_1758kW_6_46COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.46,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.44,
      capFunT =             {1.066671E+00,5.889240E-03,-3.155053E-03,-1.591039E-02,1.042897E-04,2.576256E-03},
      EIRFunT =             {7.989434E-02,2.062907E-02,-4.050827E-04,4.570552E-02,-1.469163E-04,-1.563259E-03},
      EIRFunPLR =           {3.268954E-01,3.297771E-01,3.423342E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 1758kW/6.46COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 1758kW/6.46COP/VSD,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.46,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 1758kW/6.46COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1758kW/6.46COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1758kW/6.46COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_1758kW_6_87COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         6.87,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06309,
      mCon_flow_nominal =   1000 * 0.06309,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 24.44,
      capFunT =             {8.085529E-01,3.412026E-02,-4.184591E-04,4.111323E-03,-1.764627E-04,4.184748E-04},
      EIRFunT =             {6.329473E-01,5.521802E-03,1.487172E-04,2.433576E-03,7.100129E-04,-1.108627E-03},
      EIRFunPLR =           {2.401900E-01,5.090345E-01,2.500532E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 1758kW/6.87COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 1758kW/6.87COP/Vanes,  !- Name
    1758300,                 !- Reference Capacity {W}
    6.87,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06309,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06309,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 1758kW/6.87COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1758kW/6.87COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1758kW/6.87COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1776kW_8_00COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1775900,
      COP_nominal =         8.00,
      PLRMin =              0.17,
      PLRMinUnl =           0.17,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.04757,
      mCon_flow_nominal =   1000 * 0.07003,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {4.841535E-01,-3.584260E-02,-1.467417E-03,7.773868E-02,-3.125809E-03,3.729631E-03},
      EIRFunT =             {8.006719E-01,-3.137026E-02,4.098888E-04,3.176921E-02,-2.104567E-04,-7.660277E-05},
      EIRFunPLR =           {3.276235E-01,2.787167E-01,3.952405E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes,  !- Name
    1775900,                 !- Reference Capacity {W}
    8.00,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04757,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07003,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1776kW/8.00COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.17,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.17,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XL_1779kW_6_18COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1779400,
      COP_nominal =         6.18,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.06303,
      mCon_flow_nominal =   1000 * 0.08858,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 26.11,
      capFunT =             {2.703515E-01,-4.051337E-02,-5.968813E-03,8.261488E-02,-3.019425E-03,6.718040E-03},
      EIRFunT =             {5.872331E-01,-3.907248E-02,3.474913E-04,2.950392E-02,-2.510016E-04,2.481610E-04},
      EIRFunPLR =           {3.090532E-01,2.641442E-01,4.269265E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes,  !- Name
    1779400,                 !- Reference Capacity {W}
    6.18,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06303,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.08858,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1779kW/6.18COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_1779kW_6_18COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1779400,
      COP_nominal =         6.18,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.04454,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 18.33,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {3.331346E-01,-5.678656E-02,-1.257764E-03,8.198893E-02,-2.612490E-03,4.226087E-03},
      EIRFunT =             {3.137523E-01,-1.879556E-02,-1.860907E-03,3.469711E-02,-1.503480E-04,7.641242E-04},
      EIRFunPLR =           {1.699409E-01,1.874304E-01,6.410385E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 1779kW/6.18COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 1779kW/6.18COP/Vanes,  !- Name
    1779400,                 !- Reference Capacity {W}
    6.18,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04454,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 1779kW/6.18COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1779kW/6.18COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 1779kW/6.18COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_1794kW_8_11COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1793500,
      COP_nominal =         8.11,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.08,
      mEva_flow_nominal =   1000 * 0.05148,
      mCon_flow_nominal =   1000 * 0.09653,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.536140E+00,-1.630760E-01,1.225832E-02,2.148166E-02,-1.654700E-03,2.660568E-03},
      EIRFunT =             {8.546274E-01,2.456473E-01,-9.770595E-03,-7.386557E-02,2.843499E-03,-5.292981E-03},
      EIRFunPLR =           {3.187543E-02,8.272483E-01,1.279099E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1794kW/8.11COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1794kW/8.11COP/Vanes,  !- Name
    1793500,                 !- Reference Capacity {W}
    8.11,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05148,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09653,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1794kW/8.11COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1794kW/8.11COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1794kW/8.11COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.08,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YT_1794kW_7_90COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1793500,
      COP_nominal =         7.90,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.05148,
      mCon_flow_nominal =   1000 * 0.09653,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {9.552268E-01,-1.553435E-01,7.958834E-03,6.132388E-02,-1.899594E-03,3.323245E-03},
      EIRFunT =             {5.984829E-01,-1.552700E-01,6.909012E-03,6.801572E-02,-7.450754E-04,5.764600E-04},
      EIRFunPLR =           {1.445880E-01,1.059293E-01,7.489704E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1794kW/7.90COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1794kW/7.90COP/VSD,  !- Name
    1793500,                 !- Reference Capacity {W}
    7.90,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05148,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09653,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1794kW/7.90COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1794kW/7.90COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1794kW/7.90COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XL_1797kW_5_69COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1797000,
      COP_nominal =         5.69,
      PLRMin =              0.39,
      PLRMinUnl =           0.39,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.07737,
      mCon_flow_nominal =   1000 * 0.09672,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 21.11,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {9.084596E-01,4.671596E-02,-1.188845E-03,-2.284596E-03,-3.170254E-05,-3.577858E-04},
      EIRFunT =             {1.084290E+00,-4.318103E-02,1.586113E-03,1.664015E-03,8.043383E-05,5.681056E-05},
      EIRFunPLR =           {5.926251E-01,-2.657314E-01,6.731751E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes,  !- Name
    1797000,                 !- Reference Capacity {W}
    5.69,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07737,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09672,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1797kW/5.69COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.39,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.39,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_1801kW_6_34COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1800500,
      COP_nominal =         6.34,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05161,
      mCon_flow_nominal =   1000 * 0.06385,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {6.174861E-01,-7.299051E-02,-1.897105E-03,7.003662E-02,-2.852439E-03,5.751931E-03},
      EIRFunT =             {6.931082E-01,-1.885558E-02,8.345461E-04,1.263879E-02,4.588028E-04,-8.221467E-04},
      EIRFunPLR =           {1.040764E-01,2.818752E-01,6.144036E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 1801kW/6.34COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 1801kW/6.34COP/VSD,  !- Name
    1800500,                 !- Reference Capacity {W}
    6.34,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05161,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06385,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 1801kW/6.34COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1801kW/6.34COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 1801kW/6.34COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1867kW_10_09COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1867300,
      COP_nominal =         10.09,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {4.451516E-01,-1.252382E-02,-2.878042E-03,6.132233E-02,-2.365055E-03,4.514258E-03},
      EIRFunT =             {6.668391E-01,1.506485E-02,-4.249134E-03,3.588996E-02,-1.681591E-04,7.028459E-04},
      EIRFunPLR =           {2.157002E-01,2.251016E-01,5.584287E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1867kW/10.09COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1867kW/10.09COP/Vanes,  !- Name
    1867300,                 !- Reference Capacity {W}
    10.09,                   !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1867kW/10.09COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1867kW/10.09COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1867kW/10.09COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XL_1871kW_6_49COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1870800,
      COP_nominal =         6.49,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06303,
      mCon_flow_nominal =   1000 * 0.0877,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.658630E-03,-3.836575E-02,-5.122195E-03,1.068063E-01,-3.377824E-03,5.650118E-03},
      EIRFunT =             {1.029608E+00,-7.149045E-02,2.043279E-03,-6.116474E-04,3.908334E-04,6.870233E-04},
      EIRFunPLR =           {2.984908E-01,2.906868E-01,4.089411E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes,  !- Name
    1870800,                 !- Reference Capacity {W}
    6.49,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06303,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0877,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 1871kW/6.49COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1881kW_6_77COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1881400,
      COP_nominal =         6.77,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.065247E-01,-4.158206E-03,-2.681976E-03,4.763436E-02,-1.951270E-03,3.994399E-03},
      EIRFunT =             {6.175311E-01,-3.913241E-02,6.177961E-04,2.775640E-02,-2.151466E-04,5.514895E-04},
      EIRFunPLR =           {6.087656E-02,4.842164E-01,4.571519E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1881kW/6.77COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1881kW/6.77COP/VSD,  !- Name
    1881400,                 !- Reference Capacity {W}
    6.77,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1881kW/6.77COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1881kW/6.77COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1881kW/6.77COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_1881kW_6_53COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1881400,
      COP_nominal =         6.53,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.04397,
      mCon_flow_nominal =   1000 * 0.1041,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 9.44,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {8.561286E-01,4.130164E-02,-7.109335E-04,4.306273E-03,-6.336613E-04,7.211635E-04},
      EIRFunT =             {4.434989E-01,4.361264E-02,-1.733337E-03,9.915503E-03,4.312717E-04,-1.122346E-03},
      EIRFunPLR =           {5.272116E-02,4.176382E-01,5.310870E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 1881kW/6.53COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 1881kW/6.53COP/Vanes,  !- Name
    1881400,                 !- Reference Capacity {W}
    6.53,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04397,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.1041,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 1881kW/6.53COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 1881kW/6.53COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 1881kW/6.53COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PEH_1895kW_6_42COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1895400,
      COP_nominal =         6.42,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.09,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {8.573195E-01,-1.131937E-01,3.444205E-03,4.865045E-02,-2.103805E-03,4.986639E-03},
      EIRFunT =             {3.915073E-01,-4.399727E-02,-3.868294E-06,4.623771E-02,-7.092319E-04,1.372133E-03},
      EIRFunPLR =           {2.592598E-01,1.425462E-01,5.966041E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 1895kW/6.42COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 1895kW/6.42COP/Vanes,  !- Name
    1895400,                 !- Reference Capacity {W}
    6.42,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 1895kW/6.42COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1895kW/6.42COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1895kW/6.42COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.09,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_1934kW_7_55COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1934100,
      COP_nominal =         7.55,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.05552,
      mCon_flow_nominal =   1000 * 0.08675,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 13.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {4.420318E-02,1.103599E-01,-2.597752E-03,7.043754E-02,-2.138316E-03,-4.696924E-04},
      EIRFunT =             {1.173674E+00,-1.301647E-01,5.588446E-03,8.605153E-03,7.234201E-05,1.314581E-03},
      EIRFunPLR =           {1.706237E-01,6.063362E-01,2.170672E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 1934kW/7.55COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 1934kW/7.55COP/Vanes,  !- Name
    1934100,                 !- Reference Capacity {W}
    7.55,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    13.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05552,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.08675,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 1934kW/7.55COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 1934kW/7.55COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 1934kW/7.55COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_McQuay_PEH_1934kW_6_01COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1934100,
      COP_nominal =         6.01,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.08,
      mEva_flow_nominal =   1000 * 0.05552,
      mCon_flow_nominal =   1000 * 0.07981,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {2.893111E-01,-3.834949E-02,1.757934E-03,8.665805E-02,-2.597243E-03,2.413315E-03},
      EIRFunT =             {2.885371E-01,-5.877829E-03,-1.807763E-03,5.193076E-02,-7.936373E-04,1.108590E-03},
      EIRFunPLR =           {3.849256E-01,-2.369152E-01,8.496351E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PEH 1934kW/6.01COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PEH 1934kW/6.01COP/Vanes,  !- Name
    1934100,                 !- Reference Capacity {W}
    6.01,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05552,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07981,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PEH 1934kW/6.01COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1934kW/6.01COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PEH 1934kW/6.01COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.08,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_McQuay_WDC_1973kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1972800,
      COP_nominal =         6.28,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.04145,
      mCon_flow_nominal =   1000 * 0.09337,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {1.110884E+00,7.376077E-02,-5.957719E-03,-2.861037E-02,-2.129104E-04,2.547028E-03},
      EIRFunT =             {1.097378E+00,-3.018324E-02,-2.792200E-03,-1.252428E-02,2.095232E-04,2.409252E-03},
      EIRFunPLR =           {1.282891E-01,2.722981E-01,6.012232E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay WDC 1973kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay WDC 1973kW/6.28COP/Vanes,  !- Name
    1972800,                 !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04145,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09337,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay WDC 1973kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay WDC 1973kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay WDC 1973kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_1997kW_7_24COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1997400,
      COP_nominal =         7.24,
      PLRMin =              0.18,
      PLRMinUnl =           0.18,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.04397,
      mCon_flow_nominal =   1000 * 0.1041,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 7.22,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {9.058272E-01,1.309175E-01,-3.446620E-03,-3.166792E-02,2.325200E-04,-4.892256E-04},
      EIRFunT =             {1.188194E-01,8.769791E-02,-1.692086E-03,2.209962E-03,1.327958E-03,-3.249833E-03},
      EIRFunPLR =           {9.359332E-02,5.873752E-01,3.208990E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 1997kW/7.24COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 1997kW/7.24COP/Vanes,  !- Name
    1997400,                 !- Reference Capacity {W}
    7.24,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04397,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.1041,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 1997kW/7.24COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 1997kW/7.24COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 1997kW/7.24COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.18,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.18,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PFH_2043kW_8_44COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2043100,
      COP_nominal =         8.44,
      PLRMin =              0.08,
      PLRMinUnl =           0.08,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.04757,
      mCon_flow_nominal =   1000 * 0.06814,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {8.383569E-01,4.716323E-02,-2.515385E-03,-3.773603E-03,-9.186324E-04,2.177057E-03},
      EIRFunT =             {7.891693E-01,1.168677E-02,-1.825470E-03,1.278749E-02,1.521317E-04,2.156746E-04},
      EIRFunPLR =           {1.225600E-01,3.070007E-01,5.712759E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PFH 2043kW/8.44COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PFH 2043kW/8.44COP/Vanes,  !- Name
    2043100,                 !- Reference Capacity {W}
    8.44,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04757,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.06814,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PFH 2043kW/8.44COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 2043kW/8.44COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 2043kW/8.44COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.08,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.08,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_2043kW_9_08COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2043100,
      COP_nominal =         9.08,
      PLRMin =              0.28,
      PLRMinUnl =           0.28,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 18.33,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 18.33,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {-1.340241E+00,7.634284E-03,-3.044184E-03,1.991327E-01,-4.530240E-03,2.700765E-03},
      EIRFunT =             {6.065177E-01,1.178669E-02,2.098586E-03,1.532536E-02,6.756887E-04,-2.629852E-03},
      EIRFunPLR =           {2.173752E-01,4.394720E-01,3.431813E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 2043kW/9.08COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 2043kW/9.08COP/Vanes,  !- Name
    2043100,                 !- Reference Capacity {W}
    9.08,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    18.33,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 2043kW/9.08COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2043kW/9.08COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2043kW/9.08COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.28,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.28,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XL_2057kW_6_05COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2057200,
      COP_nominal =         6.05,
      PLRMin =              0.28,
      PLRMinUnl =           0.28,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.08322,
      mCon_flow_nominal =   1000 * 0.09722,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.737452E-01,-1.249478E-02,-3.193419E-03,2.110302E-02,-1.188413E-03,3.820335E-03},
      EIRFunT =             {8.623086E-01,-5.844490E-02,-2.284745E-03,2.469188E-02,-1.022604E-03,3.996523E-03},
      EIRFunPLR =           {4.041274E-01,-3.861525E-01,9.804493E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes,  !- Name
    2057200,                 !- Reference Capacity {W}
    6.05,                    !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.08322,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09722,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XL 2057kW/6.05COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.28,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.28,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_2110kW_7_15COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2110000,
      COP_nominal =         7.15,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06057,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.359238E-01,1.785857E-02,1.579272E-03,4.522868E-02,-1.632172E-03,6.008061E-04},
      EIRFunT =             {6.270855E-01,-4.119654E-02,1.327107E-03,2.661446E-02,-1.856827E-04,5.094942E-04},
      EIRFunPLR =           {2.469187E-01,1.862690E-01,5.660904E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 2110kW/7.15COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 2110kW/7.15COP/Vanes,  !- Name
    2110000,                 !- Reference Capacity {W}
    7.15,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06057,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 2110kW/7.15COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 2110kW/7.15COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 2110kW/7.15COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_McQuay_PFH_2124kW_6_03COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2124000,
      COP_nominal =         6.03,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.05552,
      mCon_flow_nominal =   1000 * 0.07981,
      TEvaLvg_nominal =     273.15 + 8.89,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.040134E+00,-1.745650E-02,1.084856E-03,6.629328E-03,-8.008991E-04,1.567769E-03},
      EIRFunT =             {1.157799E+00,-3.621524E-02,-3.684818E-03,-1.202959E-02,-7.378548E-05,3.787365E-03},
      EIRFunPLR =           {1.051419E-01,2.033679E-01,6.902026E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PFH 2124kW/6.03COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PFH 2124kW/6.03COP/Vanes,  !- Name
    2124000,                 !- Reference Capacity {W}
    6.03,                    !- Reference COP {W/W}
    8.89,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05552,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.07981,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PFH 2124kW/6.03COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 2124kW/6.03COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 2124kW/6.03COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_2159kW_6_85COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2159200,
      COP_nominal =         6.85,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {6.322235E-01,1.553954E-02,-9.149770E-03,5.284289E-02,-2.818835E-03,7.074096E-03},
      EIRFunT =             {9.106730E-01,-3.786410E-03,-1.084261E-03,-7.148246E-03,5.178799E-04,1.818623E-05},
      EIRFunPLR =           {2.595694E-01,1.889684E-01,5.518450E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 2159kW/6.85COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 2159kW/6.85COP/Vanes,  !- Name
    2159200,                 !- Reference Capacity {W}
    6.85,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 2159kW/6.85COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 2159kW/6.85COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 2159kW/6.85COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_2184kW_6_78COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2183800,
      COP_nominal =         6.78,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04883,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 7.78,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 18.33,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.235680E+00,2.213527E-02,-1.770186E-03,-1.131594E-02,-5.008696E-04,1.356522E-03},
      EIRFunT =             {8.877947E-01,-1.334886E-02,1.689581E-03,-1.599710E-03,7.884945E-04,-1.584900E-03},
      EIRFunPLR =           {8.942647E-02,5.249540E-01,3.850801E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 2184kW/6.78COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 2184kW/6.78COP/Vanes,  !- Name
    2183800,                 !- Reference Capacity {W}
    6.78,                    !- Reference COP {W/W}
    7.78,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04883,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 2184kW/6.78COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2184kW/6.78COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2184kW/6.78COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_2201kW_6_69COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2201400,
      COP_nominal =         6.69,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.474968E-01,-4.800356E-03,-6.845886E-03,6.302552E-02,-2.911528E-03,6.598690E-03},
      EIRFunT =             {8.234137E-01,1.308264E-02,-1.147806E-03,-4.071161E-03,5.220869E-04,-6.312495E-04},
      EIRFunPLR =           {2.653493E-01,1.444620E-01,5.911158E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 2201kW/6.69COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 2201kW/6.69COP/Vanes,  !- Name
    2201400,                 !- Reference Capacity {W}
    6.69,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 2201kW/6.69COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 2201kW/6.69COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 2201kW/6.69COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_2233kW_9_54COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2233000,
      COP_nominal =         9.54,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06107,
      mCon_flow_nominal =   1000 * 0.11451,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.585741E-01,-5.127829E-02,5.848602E-03,4.235544E-02,-1.606561E-03,9.364594E-04},
      EIRFunT =             {7.563409E-01,-1.966623E-02,-3.927494E-04,2.973607E-02,1.299230E-04,-4.325357E-04},
      EIRFunPLR =           {6.917141E-02,1.743339E-01,7.524059E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 2233kW/9.54COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 2233kW/9.54COP/VSD,  !- Name
    2233000,                 !- Reference Capacity {W}
    9.54,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06107,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11451,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 2233kW/9.54COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 2233kW/9.54COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 2233kW/9.54COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YK_2237kW_6_41COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2236600,
      COP_nominal =         6.41,
      PLRMin =              0.13,
      PLRMinUnl =           0.13,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {6.899710E-01,-1.413334E-03,-1.109323E-03,4.078120E-02,-1.785625E-03,2.977821E-03},
      EIRFunT =             {8.567950E-01,3.354557E-03,1.047901E-03,-5.217250E-03,6.565310E-04,-1.361740E-03},
      EIRFunPLR =           {2.605354E-01,2.125571E-01,5.269144E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 2237kW/6.41COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 2237kW/6.41COP/Vanes,  !- Name
    2236600,                 !- Reference Capacity {W}
    6.41,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 2237kW/6.41COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 2237kW/6.41COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 2237kW/6.41COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.13,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.13,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_2275kW_6_32COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2275200,
      COP_nominal =         6.32,
      PLRMin =              0.13,
      PLRMinUnl =           0.13,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.034673E+00,-1.091064E-02,9.019479E-04,9.686229E-03,-9.160783E-04,2.045641E-03},
      EIRFunT =             {8.326094E-01,-6.056615E-03,-3.016626E-04,-2.498578E-03,4.933363E-04,-3.125632E-04},
      EIRFunPLR =           {2.735485E-01,2.163041E-01,5.099054E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 2275kW/6.32COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 2275kW/6.32COP/Vanes,  !- Name
    2275200,                 !- Reference Capacity {W}
    6.32,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 2275kW/6.32COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 2275kW/6.32COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 2275kW/6.32COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.13,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.13,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_2300kW_8_10COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2299900,
      COP_nominal =         8.10,
      PLRMin =              0.23,
      PLRMinUnl =           0.23,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09085,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {6.268137E-01,3.920902E-02,-5.475881E-04,3.072669E-02,-1.474615E-03,8.577783E-04},
      EIRFunT =             {7.178121E-01,6.561784E-03,8.193740E-06,2.319141E-02,-1.755983E-06,-8.834410E-04},
      EIRFunPLR =           {1.161399E-01,4.347344E-01,4.486380E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 2300kW/8.10COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 2300kW/8.10COP/Vanes,  !- Name
    2299900,                 !- Reference Capacity {W}
    8.10,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09085,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 2300kW/8.10COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2300kW/8.10COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2300kW/8.10COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.23,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.23,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_2317kW_6_33COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2317400,
      COP_nominal =         6.33,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.277716E-01,1.018101E-02,-6.282438E-04,1.337701E-02,-5.050352E-04,1.527259E-03},
      EIRFunT =             {3.502330E-01,-2.301510E-02,5.749596E-04,1.902421E-02,3.109974E-04,-4.714517E-04},
      EIRFunPLR =           {9.861441E-02,5.297727E-01,3.707229E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 2317kW/6.33COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 2317kW/6.33COP/VSD,  !- Name
    2317400,                 !- Reference Capacity {W}
    6.33,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 2317kW/6.33COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2317kW/6.33COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2317kW/6.33COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Carrier_19XR_2391kW_6_77COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2391300,
      COP_nominal =         6.77,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06858,
      mCon_flow_nominal =   1000 * 0.0846,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {3.676388E-01,-5.087680E-02,-1.772675E-03,9.518123E-02,-3.403878E-03,4.526983E-03},
      EIRFunT =             {6.266646E-01,-2.367443E-02,4.031296E-04,2.827714E-02,-1.985242E-04,-1.470260E-04},
      EIRFunPLR =           {3.036386E-01,2.524850E-01,4.429285E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes,  !- Name
    2391300,                 !- Reference Capacity {W}
    6.77,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06858,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0846,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 2391kW/6.77COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19XR_2391kW_6_44COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2391300,
      COP_nominal =         6.44,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.06858,
      mCon_flow_nominal =   1000 * 0.0846,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {3.676388E-01,-5.087680E-02,-1.772675E-03,9.518123E-02,-3.403878E-03,4.526983E-03},
      EIRFunT =             {6.230142E-01,-2.371649E-02,3.996265E-04,2.874515E-02,-2.115103E-04,-1.526191E-04},
      EIRFunPLR =           {9.774812E-02,2.490111E-01,6.539378E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19XR 2391kW/6.44COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19XR 2391kW/6.44COP/VSD,  !- Name
    2391300,                 !- Reference Capacity {W}
    6.44,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06858,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0846,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19XR 2391kW/6.44COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 2391kW/6.44COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19XR 2391kW/6.44COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_2412kW_5_58COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2412400,
      COP_nominal =         5.58,
      PLRMin =              0.12,
      PLRMinUnl =           0.12,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.11356,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.473817E-01,8.069214E-03,8.433986E-05,1.925706E-02,-7.505775E-04,1.174526E-03},
      EIRFunT =             {4.626807E-01,-2.305674E-02,1.169126E-03,3.431185E-02,-3.396938E-04,-7.381352E-05},
      EIRFunPLR =           {2.472427E-01,7.531481E-01,8.643617E-04},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 2412kW/5.58COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 2412kW/5.58COP/Vanes,  !- Name
    2412400,                 !- Reference Capacity {W}
    5.58,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.11356,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 2412kW/5.58COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 2412kW/5.58COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 2412kW/5.58COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.12,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.12,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PFH_2462kW_6_67COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2461600,
      COP_nominal =         6.67,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.07066,
      mCon_flow_nominal =   1000 * 0.10157,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.561527E-01,5.742999E-02,-4.868087E-03,1.799507E-02,-1.793848E-03,3.194186E-03},
      EIRFunT =             {5.462893E-01,2.854651E-02,-5.770782E-03,1.634571E-02,-2.645314E-04,2.138325E-03},
      EIRFunPLR =           {9.222135E-02,5.830980E-01,3.250019E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PFH 2462kW/6.67COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PFH 2462kW/6.67COP/Vanes,  !- Name
    2461600,                 !- Reference Capacity {W}
    6.67,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07066,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.10157,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PFH 2462kW/6.67COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 2462kW/6.67COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 2462kW/6.67COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2567100,
      COP_nominal =         11.77,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.12113,
      mCon_flow_nominal =   1000 * 0.15142,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {4.549428E-01,2.748161E-02,-4.298342E-03,4.363928E-02,-1.352509E-03,2.964225E-03},
      EIRFunT =             {4.561990E-01,-3.333063E-02,-1.763576E-03,5.624520E-02,-8.535085E-05,3.567604E-04},
      EIRFunPLR =           {1.039419E-01,4.184975E-01,4.774210E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 2567kW/11.77COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 2567kW/11.77COP/VSD,  !- Name
    2567100,                 !- Reference Capacity {W}
    11.77,                   !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.12113,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.15142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 2567kW/11.77COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2567kW/11.77COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2567kW/11.77COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_2771kW_6_84COP_VSD =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2771100,
      COP_nominal =         6.84,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.10094,
      mCon_flow_nominal =   1000 * 0.15142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.734286E-01,4.848829E-02,-1.859209E-03,2.611971E-02,-1.243562E-03,7.210181E-04},
      EIRFunT =             {7.203736E-01,1.030460E-02,-7.854237E-04,-1.206349E-03,8.210060E-04,-1.455414E-03},
      EIRFunPLR =           {8.653354E-02,1.737382E-01,7.403679E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 2771kW/6.84COP/VSD" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 2771kW/6.84COP/VSD,  !- Name
    2771100,                 !- Reference Capacity {W}
    6.84,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.10094,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.15142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 2771kW/6.84COP/VSD CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 2771kW/6.84COP/VSD EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 2771kW/6.84COP/VSD EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_2799kW_6_40COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -2799200,
      COP_nominal =         6.40,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.09893,
      mCon_flow_nominal =   1000 * 0.13761,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {2.210324E-01,-2.752320E-02,4.903763E-04,7.337449E-02,-1.919426E-03,1.935659E-03},
      EIRFunT =             {2.267558E-01,-7.615857E-02,2.140583E-03,7.088812E-02,-1.124968E-03,6.089843E-04},
      EIRFunPLR =           {3.023576E-01,-2.893592E-02,7.262269E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 2799kW/6.40COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 2799kW/6.40COP/Vanes,  !- Name
    2799200,                 !- Reference Capacity {W}
    6.40,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.09893,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.13761,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 2799kW/6.40COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2799kW/6.40COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 2799kW/6.40COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YT_3133kW_9_16COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -3133300,
      COP_nominal =         9.16,
      PLRMin =              0.07,
      PLRMinUnl =           0.07,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.08076,
      mCon_flow_nominal =   1000 * 0.12618,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.607419E-01,1.323998E-02,6.902287E-04,1.510969E-02,-9.443341E-04,1.484396E-03},
      EIRFunT =             {9.150153E-01,-3.956395E-02,1.865473E-03,1.810633E-02,2.900613E-04,-4.199110E-04},
      EIRFunPLR =           {1.387579E-01,6.435208E-01,2.155990E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YT 3133kW/9.16COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YT 3133kW/9.16COP/Vanes,  !- Name
    3133300,                 !- Reference Capacity {W}
    9.16,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.08076,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.12618,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YT 3133kW/9.16COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YT 3133kW/9.16COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YT 3133kW/9.16COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.07,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.07,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_McQuay_PFH_3165kW_6_48COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -3165000,
      COP_nominal =         6.48,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.09085,
      mCon_flow_nominal =   1000 * 0.13627,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 22.78,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {1.342558E+00,7.520735E-02,-8.988936E-03,-3.340001E-02,-6.065934E-04,4.684791E-03},
      EIRFunT =             {9.347904E-01,6.551597E-02,-1.242676E-02,-2.799974E-02,3.323287E-04,4.803491E-03},
      EIRFunPLR =           {1.054110E-01,4.090646E-01,4.838839E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PFH 3165kW/6.48COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PFH 3165kW/6.48COP/Vanes,  !- Name
    3165000,                 !- Reference Capacity {W}
    6.48,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    22.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.09085,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.13627,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PFH 3165kW/6.48COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 3165kW/6.48COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 3165kW/6.48COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_McQuay_PFH_4020kW_7_35COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4019500,
      COP_nominal =         7.35,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.07874,
      mCon_flow_nominal =   1000 * 0.09842,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 12.78,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {8.958422E-01,3.762768E-02,-3.550080E-03,-4.322645E-03,-1.194933E-03,3.006034E-03},
      EIRFunT =             {9.322623E-01,-2.157964E-02,-1.435883E-03,1.379036E-02,-1.491048E-04,1.302075E-03},
      EIRFunPLR =           {5.763566E-02,5.964012E-01,3.473613E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller McQuay PFH 4020kW/7.35COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller McQuay PFH 4020kW/7.35COP/Vanes,  !- Name
    4019500,                 !- Reference Capacity {W}
    7.35,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    12.78,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07874,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09842,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller McQuay PFH 4020kW/7.35COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 4020kW/7.35COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller McQuay PFH 4020kW/7.35COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_4396kW_6_63COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4395800,
      COP_nominal =         6.63,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {3.693621E-01,-7.284715E-02,-4.871930E-03,1.223355E-01,-5.368259E-03,1.035036E-02},
      EIRFunT =             {5.913358E-01,-5.974145E-02,8.176561E-04,3.987353E-02,-8.176694E-04,1.457994E-03},
      EIRFunPLR =           {3.021070E-01,3.103971E-02,6.669726E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 4396kW/6.63COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 4396kW/6.63COP/Vanes,  !- Name
    4395800,                 !- Reference Capacity {W}
    6.63,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 4396kW/6.63COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 4396kW/6.63COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 4396kW/6.63COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_4477kW_6_64COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4476700,
      COP_nominal =         6.64,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {4.844230E-01,-9.879643E-02,-2.516527E-03,1.144722E-01,-5.101526E-03,1.022861E-02},
      EIRFunT =             {4.264570E-01,-3.391606E-02,-1.991396E-03,5.032090E-02,-1.140771E-03,1.814692E-03},
      EIRFunPLR =           {2.767206E-01,1.074393E-01,6.145706E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 4477kW/6.64COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 4477kW/6.64COP/Vanes,  !- Name
    4476700,                 !- Reference Capacity {W}
    6.64,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 4477kW/6.64COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 4477kW/6.64COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 4477kW/6.64COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_4515kW_6_22COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4515400,
      COP_nominal =         6.22,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {3.732405E-01,-7.176618E-03,-2.588788E-03,5.381225E-02,-1.773937E-03,3.509721E-03},
      EIRFunT =             {5.908290E-01,1.028668E-02,-4.718838E-04,1.220347E-02,4.166971E-04,-1.484327E-03},
      EIRFunPLR =           {2.870815E-01,3.951784E-01,3.177735E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 4515kW/6.22COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 4515kW/6.22COP/Vanes,  !- Name
    4515400,                 !- Reference Capacity {W}
    6.22,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 4515kW/6.22COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 4515kW/6.22COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 4515kW/6.22COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_4537kW_6_28COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4536500,
      COP_nominal =         6.28,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {9.418253E-01,8.142292E-02,-9.532713E-03,3.185018E-02,-2.583116E-03,5.294716E-03},
      EIRFunT =             {7.709829E-01,-2.257680E-02,2.492708E-04,7.635418E-03,3.376522E-04,-3.614203E-04},
      EIRFunPLR =           {2.528426E-01,2.920280E-01,4.533447E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 4537kW/6.28COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 4537kW/6.28COP/Vanes,  !- Name
    4536500,                 !- Reference Capacity {W}
    6.28,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 4537kW/6.28COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 4537kW/6.28COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 4537kW/6.28COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_4610kW_6_34COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4610300,
      COP_nominal =         6.34,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.19129,
      mCon_flow_nominal =   1000 * 0.24757,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 18.33,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {8.614836E-01,-3.988130E-03,-1.643579E-03,8.882312E-03,-3.930474E-04,1.593969E-03},
      EIRFunT =             {7.415078E-01,-4.779029E-02,-1.028085E-03,1.423650E-02,1.304315E-04,9.170177E-04},
      EIRFunPLR =           {2.026691E-01,2.922585E-01,5.044422E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 4610kW/6.34COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 4610kW/6.34COP/Vanes,  !- Name
    4610300,                 !- Reference Capacity {W}
    6.34,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.19129,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24757,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 4610kW/6.34COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 4610kW/6.34COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 4610kW/6.34COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19EX_4667kW_6_16COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4666600,
      COP_nominal =         6.16,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {4.084496E-01,-4.396326E-02,-2.112120E-03,8.225310E-02,-3.066058E-03,5.257550E-03},
      EIRFunT =             {5.214788E-01,-8.218594E-03,-3.068358E-05,2.152332E-02,1.203908E-04,-7.167755E-04},
      EIRFunPLR =           {3.771252E-01,2.854188E-02,5.928670E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes,  !- Name
    4666600,                 !- Reference Capacity {W}
    6.16,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 4667kW/6.16COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CVHF_4677kW_6_27COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4677100,
      COP_nominal =         6.27,
      PLRMin =              0.41,
      PLRMinUnl =           0.41,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.20138,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {8.449416E-01,-2.116553E-02,6.121458E-03,7.120879E-03,-1.798959E-04,-1.349219E-04},
      EIRFunT =             {8.283132E-01,-3.030491E-02,4.164965E-03,-3.278448E-03,6.762508E-04,-1.107762E-03},
      EIRFunPLR =           {3.531562E-01,-2.126229E-01,8.597400E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CVHF 4677kW/6.27COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CVHF 4677kW/6.27COP/Vanes,  !- Name
    4677100,                 !- Reference Capacity {W}
    6.27,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.20138,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CVHF 4677kW/6.27COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 4677kW/6.27COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CVHF 4677kW/6.27COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.41,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.41,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_4966kW_6_05COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4965500,
      COP_nominal =         6.05,
      PLRMin =              0.12,
      PLRMinUnl =           0.12,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.21198,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.746486E-01,-3.051134E-02,-1.964984E-04,3.309783E-02,-9.174714E-04,2.287276E-03},
      EIRFunT =             {8.229769E-01,-8.128614E-03,1.110212E-03,-3.521351E-03,6.129803E-04,-9.170063E-04},
      EIRFunPLR =           {3.416463E-01,1.947185E-01,4.640804E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 4966kW/6.05COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 4966kW/6.05COP/Vanes,  !- Name
    4965500,                 !- Reference Capacity {W}
    6.05,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.21198,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 4966kW/6.05COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 4966kW/6.05COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 4966kW/6.05COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.12,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.12,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_4969kW_7_14COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4969000,
      COP_nominal =         7.14,
      PLRMin =              0.16,
      PLRMinUnl =           0.16,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.17665,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {7.817577E-01,-1.012013E-01,-1.584389E-03,7.928475E-02,-3.674093E-03,7.999392E-03},
      EIRFunT =             {7.382162E-01,-5.847442E-02,1.117191E-03,2.168089E-02,-2.189722E-04,1.036877E-03},
      EIRFunPLR =           {2.259512E-01,2.320151E-01,5.423771E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 4969kW/7.14COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 4969kW/7.14COP/Vanes,  !- Name
    4969000,                 !- Reference Capacity {W}
    7.14,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.17665,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 4969kW/7.14COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 4969kW/7.14COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 4969kW/7.14COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.16,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.16,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_4969kW_7_07COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4969000,
      COP_nominal =         7.07,
      PLRMin =              0.16,
      PLRMinUnl =           0.16,
      PLRMax =              1.06,
      mEva_flow_nominal =   1000 * 0.17665,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.803605E-01,-9.685535E-02,-5.831135E-03,1.341596E-01,-5.279908E-03,1.045372E-02},
      EIRFunT =             {7.220087E-01,-4.480691E-02,9.621038E-06,2.084835E-02,-2.615973E-04,1.188407E-03},
      EIRFunPLR =           {2.308102E-01,1.802734E-01,5.894894E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 4969kW/7.07COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 4969kW/7.07COP/Vanes,  !- Name
    4969000,                 !- Reference Capacity {W}
    7.07,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.17665,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 4969kW/7.07COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 4969kW/7.07COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 4969kW/7.07COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.16,                    !- Minimum Part Load Ratio
    1.06,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.16,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19EX_4997kW_6_40COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -4997200,
      COP_nominal =         6.40,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.19558,
      mCon_flow_nominal =   1000 * 0.24605,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.67,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.67,
      capFunT =             {7.122762E-02,2.550937E-03,-9.679482E-03,9.391204E-02,-3.505261E-03,7.309943E-03},
      EIRFunT =             {6.685097E-01,-2.541433E-02,3.334144E-03,1.002578E-02,5.753780E-04,-1.801340E-03},
      EIRFunPLR =           {3.364887E-01,2.122607E-01,4.486522E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes,  !- Name
    4997200,                 !- Reference Capacity {W}
    6.40,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.67,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.19558,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.24605,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 4997kW/6.40COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19EX_5148kW_6_34COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -5148400,
      COP_nominal =         6.34,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.18283,
      mCon_flow_nominal =   1000 * 0.25526,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {3.564454E-01,2.020689E-02,-6.286899E-03,5.760425E-02,-2.102376E-03,4.126650E-03},
      EIRFunT =             {5.426449E-01,3.961314E-03,-1.195821E-04,1.609421E-02,3.089258E-04,-1.129525E-03},
      EIRFunPLR =           {1.883602E-01,5.018646E-01,3.089569E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes,  !- Name
    5148400,                 !- Reference Capacity {W}
    6.34,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.18283,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.25526,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 5148kW/6.34COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_5170kW_7_15COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -5169500,
      COP_nominal =         7.15,
      PLRMin =              0.15,
      PLRMinUnl =           0.15,
      PLRMax =              1.08,
      mEva_flow_nominal =   1000 * 0.17665,
      mCon_flow_nominal =   1000 * 0.26498,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.675697E-01,-1.191228E-01,-4.328384E-03,1.355905E-01,-5.171251E-03,1.039840E-02},
      EIRFunT =             {5.894383E-01,-2.926530E-02,-1.900238E-03,2.849479E-02,-5.105015E-04,1.702334E-03},
      EIRFunPLR =           {2.497273E-01,1.011288E-01,6.499847E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 5170kW/7.15COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 5170kW/7.15COP/Vanes,  !- Name
    5169500,                 !- Reference Capacity {W}
    7.15,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.17665,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.26498,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 5170kW/7.15COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 5170kW/7.15COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 5170kW/7.15COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.15,                    !- Minimum Part Load Ratio
    1.08,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.15,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19EX_5208kW_6_88COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -5208200,
      COP_nominal =         6.88,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.18283,
      mCon_flow_nominal =   1000 * 0.25293,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.563516E-01,-4.106264E-02,-3.164992E-03,5.722234E-02,-2.313857E-03,5.377616E-03},
      EIRFunT =             {5.198204E-01,-1.523340E-02,-6.391523E-04,2.170049E-02,2.423693E-05,1.432604E-04},
      EIRFunPLR =           {2.334262E-01,3.926783E-01,3.731320E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes,  !- Name
    5208200,                 !- Reference Capacity {W}
    6.88,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.18283,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.25293,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19EX 5208kW/6.88COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_5465kW_6_94COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -5464900,
      COP_nominal =         6.94,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.07,
      mEva_flow_nominal =   1000 * 0.18296,
      mCon_flow_nominal =   1000 * 0.27444,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.092441E-01,-1.225892E-01,-2.802873E-03,1.324138E-01,-4.714937E-03,9.205744E-03},
      EIRFunT =             {6.396022E-01,-5.954060E-02,5.884523E-04,3.170651E-02,-5.088216E-04,1.460759E-03},
      EIRFunPLR =           {2.795792E-01,7.872758E-02,6.424321E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 5465kW/6.94COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 5465kW/6.94COP/Vanes,  !- Name
    5464900,                 !- Reference Capacity {W}
    6.94,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.18296,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.27444,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 5465kW/6.94COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 5465kW/6.94COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 5465kW/6.94COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.07,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YK_5549kW_6_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -5549300,
      COP_nominal =         6.50,
      PLRMin =              0.14,
      PLRMinUnl =           0.14,
      PLRMax =              1.05,
      mEva_flow_nominal =   1000 * 0.18296,
      mCon_flow_nominal =   1000 * 0.27444,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 26.11,
      capFunT =             {-1.402079E-01,1.836029E-02,-2.390588E-03,1.207956E-01,-3.563147E-03,2.024532E-03},
      EIRFunT =             {4.989980E-01,-8.246157E-02,6.047523E-03,5.168793E-02,-8.552445E-04,6.275326E-05},
      EIRFunPLR =           {2.336623E-01,1.901320E-01,5.749473E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YK 5549kW/6.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YK 5549kW/6.50COP/Vanes,  !- Name
    5549300,                 !- Reference Capacity {W}
    6.50,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.18296,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.27444,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YK 5549kW/6.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YK 5549kW/6.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YK 5549kW/6.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.14,                    !- Minimum Part Load Ratio
    1.05,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.14,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_19FA_5651kW_5_50COP_Vanes =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -5651300,
      COP_nominal =         5.50,
      PLRMin =              0.19,
      PLRMinUnl =           0.19,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.18927,
      mCon_flow_nominal =   1000 * 0.18927,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.299676E+00,1.790645E-02,-2.522300E-03,2.536423E-03,-1.128041E-03,3.003265E-03},
      EIRFunT =             {7.853207E-01,-1.652255E-02,-3.294526E-04,4.569179E-03,1.964013E-04,1.761497E-04},
      EIRFunPLR =           {1.629327E-01,5.709336E-01,2.659304E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes,  !- Name
    5651300,                 !- Reference Capacity {W}
    5.50,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.18927,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.18927,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 19FA 5651kW/5.50COP/Vanes EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.19,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.19,                    !- Minimum Unloading Ratio
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

  record DOE_2_Centrifugal_5_50COP =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -100000.0,
      COP_nominal =         5.5,
      PLRMin =              0.1,
      PLRMinUnl =           0.2,
      PLRMax =              1.0,
      mEva_flow_nominal =   1000 * 0.0022,
      mCon_flow_nominal =   1000 * 0.0041,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.4,
      TEvaLvgMin =          273.15 + 5.0,
      TEvaLvgMax =          273.15 + 10.0,
      TConEntMin =          273.15 + 24.0,
      TConEntMax =          273.15 + 35.0,
      capFunT =             {0.257896E+00,0.389016E-01,-0.217080E-03,0.468684E-01,-0.942840E-03,-0.343440E-03},
      EIRFunT =             {0.933884E+00,-0.582120E-01,0.450036E-02,0.243000E-02,0.486000E-03,-0.121500E-02},
      EIRFunPLR =           {0.222903,0.313387,0.463710},
      etaMotor =            1.0) "DOE-2 Centrifugal/5.50COP" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    DOE-2 Centrifugal/5.50COP,  !- Name
    Autosize,                !- Reference Capacity {W}
    5.5,                     !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.4,                    !- Reference Entering Condenser Fluid Temperature {C}
    Autosize,                !- Reference Chilled Water Flow Rate {m3/s}
    Autosize,                !- Reference Condenser Water Flow Rate {m3/s}
    DOE-2 Centrifugal/5.50COP CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    DOE-2 Centrifugal/5.50COP EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    DOE-2 Centrifugal/5.50COP EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.1,                     !- Minimum Part Load Ratio
    1.0,                     !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.2,                     !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    WaterCooled,             !- Condenser Type
    ,                        !- Condenser Fan Power Ratio {W/W}
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow;            !- Chiller Flow Mode

</pre>
</html>"));

  record ElectricEIRChiller_Multistack_MS_172kW_3_67COP_None =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -172300,
      COP_nominal =         3.67,
      PLRMin =              0.40,
      PLRMinUnl =           0.40,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.00738,
      mCon_flow_nominal =   1000 * 0.00959,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 18.33,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 18.33,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {9.839419E-01,1.094957E-01,-4.547595E-03,-2.311886E-02,2.595943E-04,-5.093307E-04},
      EIRFunT =             {9.396181E-01,-5.754225E-02,2.561677E-03,1.081450E-02,1.839935E-04,5.269319E-05},
      EIRFunPLR =           {4.747786E-03,1.072374E+00,-7.758317E-02},
      etaMotor =            1.0)
    "ElectricEIRChiller Multistack MS 172kW/3.67COP/None" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Multistack MS 172kW/3.67COP/None,  !- Name
    172300,                  !- Reference Capacity {W}
    3.67,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    18.33,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.00738,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.00959,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Multistack MS 172kW/3.67COP/None CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Multistack MS 172kW/3.67COP/None EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Multistack MS 172kW/3.67COP/None EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.40,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.40,                    !- Minimum Unloading Ratio
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

  record DOE_2_Reciprocating_3_67COP =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -100000.0,
      COP_nominal =         3.67,
      PLRMin =              0.1,
      PLRMinUnl =           0.2,
      PLRMax =              1.0,
      mEva_flow_nominal =   1000 * 0.0022,
      mCon_flow_nominal =   1000 * 0.0044,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.4,
      TEvaLvgMin =          273.15 + 5.0,
      TEvaLvgMax =          273.15 + 10.0,
      TConEntMin =          273.15 + 24.0,
      TConEntMax =          273.15 + 35.0,
      capFunT =             {0.507883E+00,0.145228E+00,-0.625644E-02,-0.111780E-02,-0.129600E-03,-0.281880E-03},
      EIRFunT =             {0.103076E+01,-0.103536E+00,0.710208E-02,0.931860E-02,0.317520E-03,-0.104328E-02},
      EIRFunPLR =           {0.088065,1.137742,-0.225806},
      etaMotor =            1.0) "DOE-2 Reciprocating/3.67COP" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    DOE-2 Reciprocating/3.67COP,  !- Name
    Autosize,                !- Reference Capacity {W}
    3.67,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.4,                    !- Reference Entering Condenser Fluid Temperature {C}
    Autosize,                !- Reference Chilled Water Flow Rate {m3/s}
    Autosize,                !- Reference Condenser Water Flow Rate {m3/s}
    DOE-2 Reciprocating/3.67COP CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    DOE-2 Reciprocating/3.67COP EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    DOE-2 Reciprocating/3.67COP EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.1,                     !- Minimum Part Load Ratio
    1.0,                     !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.2,                     !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    WaterCooled,             !- Condenser Type
    ,                        !- Condenser Fan Power Ratio {W/W}
    1.0,                     !- Compressor Motor Efficiency
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow;            !- Chiller Flow Mode

</pre>
</html>"));

  record ElectricEIRChiller_Trane_RTWA_383kW_4_17COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -383300,
      COP_nominal =         4.17,
      PLRMin =              0.25,
      PLRMinUnl =           0.25,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.0165,
      mCon_flow_nominal =   1000 * 0.02063,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 23.89,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {9.830684E-01,3.676199E-02,5.307995E-05,-4.828624E-03,-4.755963E-05,-2.377982E-04},
      EIRFunT =             {6.228513E-01,-8.700783E-03,9.719796E-04,5.184584E-03,4.951699E-04,-9.632370E-04},
      EIRFunPLR =           {3.295553E-02,9.114398E-01,5.565265E-02},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTWA 383kW/4.17COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTWA 383kW/4.17COP/Valve,  !- Name
    383300,                  !- Reference Capacity {W}
    4.17,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.0165,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.02063,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTWA 383kW/4.17COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTWA 383kW/4.17COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTWA 383kW/4.17COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.25,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.25,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_RTHB_531kW_4_83COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -531000,
      COP_nominal =         4.83,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.0135,
      mCon_flow_nominal =   1000 * 0.01577,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.434012E-01,1.630729E-02,8.621098E-04,3.242384E-03,-3.003973E-04,1.931126E-04},
      EIRFunT =             {4.524778E-01,1.045156E-04,6.932509E-05,2.044980E-02,3.672953E-04,-1.099051E-03},
      EIRFunPLR =           {1.980020E-01,2.733157E-01,5.277318E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHB 531kW/4.83COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHB 531kW/4.83COP/Valve,  !- Name
    531000,                  !- Reference Capacity {W}
    4.83,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.0135,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.01577,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHB 531kW/4.83COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 531kW/4.83COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 531kW/4.83COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_RTHB_538kW_5_12COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -538000,
      COP_nominal =         5.12,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01375,
      mCon_flow_nominal =   1000 * 0.01956,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.344780E-01,2.760000E-02,3.781512E-04,-9.176470E-04,-1.270588E-04,-4.235294E-05},
      EIRFunT =             {5.455087E-01,-9.301201E-03,5.012361E-04,1.432870E-02,4.719381E-04,-8.937669E-04},
      EIRFunPLR =           {1.816950E-01,3.731838E-01,4.448009E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHB 538kW/5.12COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHB 538kW/5.12COP/Valve,  !- Name
    538000,                  !- Reference Capacity {W}
    5.12,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01375,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01956,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHB 538kW/5.12COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 538kW/5.12COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 538kW/5.12COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_RTHB_542kW_5_26COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -541500,
      COP_nominal =         5.26,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01363,
      mCon_flow_nominal =   1000 * 0.01577,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 21.11,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.226438E-01,2.878831E-02,3.756957E-04,-1.963636E-03,-8.415584E-05,-1.262338E-04},
      EIRFunT =             {4.953775E-01,-1.359340E-02,5.784637E-04,2.778142E-02,1.747259E-04,-8.590768E-04},
      EIRFunPLR =           {3.057645E-01,-1.548084E-01,8.484536E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHB 542kW/5.26COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHB 542kW/5.26COP/Valve,  !- Name
    541500,                  !- Reference Capacity {W}
    5.26,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    21.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01363,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01577,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHB 542kW/5.26COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 542kW/5.26COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 542kW/5.26COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YS_672kW_7_90COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -671600,
      COP_nominal =         7.90,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01514,
      mCon_flow_nominal =   1000 * 0.0241,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 15.56,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.274375E-01,2.846559E-02,4.024428E-04,-5.932730E-03,-1.067418E-05,-2.199015E-04},
      EIRFunT =             {4.069331E-01,-6.420922E-03,2.689257E-04,4.500373E-02,1.583981E-04,-1.284532E-03},
      EIRFunPLR =           {1.936152E-01,3.375574E-01,4.704892E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YS 672kW/7.90COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YS 672kW/7.90COP/Valve,  !- Name
    671600,                  !- Reference Capacity {W}
    7.90,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    15.56,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01514,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.0241,                  !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YS 672kW/7.90COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YS 672kW/7.90COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YS 672kW/7.90COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_686kW_5_91COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -685700,
      COP_nominal =         5.91,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.0571,
      mCon_flow_nominal =   1000 * 0.03255,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 23.74,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {2.903523E-01,-2.676742E-02,-4.771695E-03,8.162394E-02,-3.028217E-03,5.712524E-03},
      EIRFunT =             {5.014060E-01,1.561000E-03,-1.347980E-04,1.525028E-02,5.701374E-04,-1.221374E-03},
      EIRFunPLR =           {2.113934E-01,4.190226E-01,3.686143E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 686kW/5.91COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 686kW/5.91COP/Valve,  !- Name
    685700,                  !- Reference Capacity {W}
    5.91,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    23.74,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.0571,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.03255,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 686kW/5.91COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 686kW/5.91COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 686kW/5.91COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_RTHC_707kW_7_77COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -706800,
      COP_nominal =         7.77,
      PLRMin =              0.28,
      PLRMinUnl =           0.28,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04921,
      mCon_flow_nominal =   1000 * 0.03268,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 15.56,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 11.11,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.362925E-01,2.940722E-02,5.726999E-04,-5.696483E-03,-5.569609E-05,-1.708132E-04},
      EIRFunT =             {6.497944E-01,6.883157E-03,-5.277681E-04,1.725788E-02,6.779317E-04,-1.244055E-03},
      EIRFunPLR =           {1.997099E-01,6.754676E-01,1.243767E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHC 707kW/7.77COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHC 707kW/7.77COP/Valve,  !- Name
    706800,                  !- Reference Capacity {W}
    7.77,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    15.56,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04921,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03268,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHC 707kW/7.77COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 707kW/7.77COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 707kW/7.77COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.28,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.28,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YS_756kW_7_41COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -756000,
      COP_nominal =         7.41,
      PLRMin =              0.11,
      PLRMinUnl =           0.11,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 16.06,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 16.06,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.432455E-01,2.794778E-02,2.937753E-04,-5.818549E-03,-3.764392E-05,-5.777607E-05},
      EIRFunT =             {6.917947E-01,-1.929936E-02,1.450011E-03,1.795987E-02,9.301685E-04,-1.755165E-03},
      EIRFunPLR =           {2.929778E-01,1.673799E-02,6.881229E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YS 756kW/7.41COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YS 756kW/7.41COP/Valve,  !- Name
    756000,                  !- Reference Capacity {W}
    7.41,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    16.06,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YS 756kW/7.41COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YS 756kW/7.41COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YS 756kW/7.41COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.11,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.11,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YS_781kW_5_42COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -780700,
      COP_nominal =         5.42,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.01893,
      mCon_flow_nominal =   1000 * 0.03785,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {1.002148E+00,3.300191E-02,3.741670E-04,-5.925358E-03,-2.599267E-05,-2.172126E-04},
      EIRFunT =             {4.475957E-01,-1.054652E-02,7.126870E-04,1.158632E-02,5.151510E-04,-9.831355E-04},
      EIRFunPLR =           {2.519108E-01,2.756914E-01,4.725826E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YS 781kW/5.42COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YS 781kW/5.42COP/Valve,  !- Name
    780700,                  !- Reference Capacity {W}
    5.42,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.01893,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.03785,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YS 781kW/5.42COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YS 781kW/5.42COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YS 781kW/5.42COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_830kW_6_97COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -829900,
      COP_nominal =         6.97,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04744,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 14.17,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {8.198506E-01,4.299516E-03,-2.451574E-04,1.431034E-02,-3.586302E-04,2.510412E-04},
      EIRFunT =             {4.610959E-01,-1.560459E-02,-2.737454E-04,2.650593E-02,-7.789498E-05,1.855843E-04},
      EIRFunPLR =           {2.307464E-01,7.784162E-01,-7.516503E-03},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 830kW/6.97COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 830kW/6.97COP/Valve,  !- Name
    829900,                  !- Reference Capacity {W}
    6.97,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04744,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 830kW/6.97COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 830kW/6.97COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 830kW/6.97COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_862kW_6_11COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -861500,
      COP_nominal =         6.11,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04296,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {-3.646458E-02,-6.061334E-02,-3.708583E-03,1.197997E-01,-3.723397E-03,5.368766E-03},
      EIRFunT =             {5.420642E-01,-2.110032E-02,1.513908E-03,2.067897E-02,5.287518E-04,-1.630330E-03},
      EIRFunPLR =           {2.292819E-01,3.662723E-01,4.032019E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 862kW/6.11COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 862kW/6.11COP/Valve,  !- Name
    861500,                  !- Reference Capacity {W}
    6.11,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04296,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 862kW/6.11COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 862kW/6.11COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 862kW/6.11COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_862kW_6_84COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -861500,
      COP_nominal =         6.84,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.06782,
      mCon_flow_nominal =   1000 * 0.04296,
      TEvaLvg_nominal =     273.15 + 9.69,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {-4.535842E-02,-6.253871E-02,-3.623064E-03,1.218299E-01,-3.793440E-03,5.404739E-03},
      EIRFunT =             {5.930611E-01,-2.082914E-02,1.600282E-03,2.352564E-02,5.992247E-04,-1.907335E-03},
      EIRFunPLR =           {1.145826E-01,7.340475E-01,1.507744E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 862kW/6.84COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 862kW/6.84COP/Valve,  !- Name
    861500,                  !- Reference Capacity {W}
    6.84,                    !- Reference COP {W/W}
    9.69,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.06782,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04296,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 862kW/6.84COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 862kW/6.84COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 862kW/6.84COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_865kW_6_05COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -865100,
      COP_nominal =         6.05,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03716,
      mCon_flow_nominal =   1000 * 0.04366,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {5.079758E-01,-2.344768E-02,-3.296630E-03,3.508384E-02,-8.359630E-04,2.585294E-03},
      EIRFunT =             {5.437328E-01,7.625344E-03,-9.201579E-05,1.339616E-03,8.286757E-04,-1.543530E-03},
      EIRFunPLR =           {2.545235E-01,3.104981E-01,4.347781E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 865kW/6.05COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 865kW/6.05COP/Valve,  !- Name
    865100,                  !- Reference Capacity {W}
    6.05,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03716,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04366,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 865kW/6.05COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 865kW/6.05COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 865kW/6.05COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YS_879kW_5_82COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -879100,
      COP_nominal =         5.82,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.03785,
      mCon_flow_nominal =   1000 * 0.04732,
      TEvaLvg_nominal =     273.15 + 4.44,
      TConEnt_nominal =     273.15 + 26.11,
      TEvaLvgMin =          273.15 + 3.33,
      TEvaLvgMax =          273.15 + 7.78,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.031429E+00,3.364723E-02,-2.735093E-04,-3.789167E-03,-1.553912E-04,2.782117E-04},
      EIRFunT =             {5.595308E-01,-1.087985E-02,8.721022E-04,1.010347E-02,5.087454E-04,-1.211319E-03},
      EIRFunPLR =           {3.029493E-01,3.223124E-01,3.751948E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YS 879kW/5.82COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YS 879kW/5.82COP/Valve,  !- Name
    879100,                  !- Reference Capacity {W}
    5.82,                    !- Reference COP {W/W}
    4.44,                    !- Reference Leaving Chilled Water Temperature {C}
    26.11,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03785,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04732,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YS 879kW/5.82COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YS 879kW/5.82COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YS 879kW/5.82COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_Trane_RTHC_1009kW_5_37COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1009200,
      COP_nominal =         5.37,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03186,
      mCon_flow_nominal =   1000 * 0.04618,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 24.86,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 19.97,
      TConEntMax =          273.15 + 24.86,
      capFunT =             {1.134633E+00,3.267210E-02,5.266344E-04,-1.076173E-02,-4.853769E-05,-2.569325E-04},
      EIRFunT =             {4.383883E-01,7.754235E-03,6.353809E-04,-2.951880E-03,1.270756E-03,-1.541831E-03},
      EIRFunPLR =           {1.316727E-01,1.013111E+00,-1.413213E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHC 1009kW/5.37COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHC 1009kW/5.37COP/Valve,  !- Name
    1009200,                 !- Reference Capacity {W}
    5.37,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    24.86,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03186,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04618,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHC 1009kW/5.37COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 1009kW/5.37COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 1009kW/5.37COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_RTHB_1051kW_5_05COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1051400,
      COP_nominal =         5.05,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04527,
      mCon_flow_nominal =   1000 * 0.05659,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 23.89,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {9.482157E-01,3.306737E-02,-6.450072E-05,-3.756522E-03,-6.501672E-05,2.517986E-15},
      EIRFunT =             {4.904181E-01,-5.530317E-03,1.209907E-03,9.122333E-03,5.923591E-04,-1.469958E-03},
      EIRFunPLR =           {2.590465E-01,2.148987E-01,5.265039E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHB 1051kW/5.05COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHB 1051kW/5.05COP/Valve,  !- Name
    1051400,                 !- Reference Capacity {W}
    5.05,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04527,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05659,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHB 1051kW/5.05COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 1051kW/5.05COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHB 1051kW/5.05COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_1062kW_5_50COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1062000,
      COP_nominal =         5.50,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04573,
      mCon_flow_nominal =   1000 * 0.05716,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 21.11,
      TConEntMax =          273.15 + 29.44,
      capFunT =             {1.025695E+00,2.327484E-02,-4.693708E-03,-7.092715E-03,-3.754967E-04,2.843046E-03},
      EIRFunT =             {2.634070E-01,-7.025220E-03,-4.942613E-04,2.516931E-02,1.712769E-04,-4.309735E-04},
      EIRFunPLR =           {2.576261E-01,3.416910E-01,4.007672E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 1062kW/5.50COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 1062kW/5.50COP/Valve,  !- Name
    1062000,                 !- Reference Capacity {W}
    5.50,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04573,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05716,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 1062kW/5.50COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 1062kW/5.50COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 1062kW/5.50COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_RTHC_1066kW_5_73COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1065500,
      COP_nominal =         5.73,
      PLRMin =              0.30,
      PLRMinUnl =           0.30,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.05142,
      mCon_flow_nominal =   1000 * 0.04416,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 25.28,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 20.07,
      TConEntMax =          273.15 + 25.28,
      capFunT =             {1.062396E+00,4.575299E-02,2.802795E-04,-8.802343E-03,-3.127891E-05,-5.937227E-04},
      EIRFunT =             {9.003080E-01,3.783201E-03,9.815780E-04,-4.051727E-02,2.037095E-03,-1.619326E-03},
      EIRFunPLR =           {1.007344E-01,1.119205E+00,-2.173230E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHC 1066kW/5.73COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHC 1066kW/5.73COP/Valve,  !- Name
    1065500,                 !- Reference Capacity {W}
    5.73,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    25.28,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.05142,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04416,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHC 1066kW/5.73COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 1066kW/5.73COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 1066kW/5.73COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.30,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.30,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_RTHC_1094kW_6_55COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1093600,
      COP_nominal =         6.55,
      PLRMin =              0.25,
      PLRMinUnl =           0.25,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.04921,
      mCon_flow_nominal =   1000 * 0.04524,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 23.33,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.643756E-01,3.820069E-02,4.611891E-04,-5.174840E-03,-5.784404E-05,-2.944185E-04},
      EIRFunT =             {6.579136E-01,-1.133448E-02,6.497057E-04,7.318160E-03,6.167738E-04,-9.553369E-04},
      EIRFunPLR =           {1.626466E-01,7.903550E-01,4.770888E-02},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane RTHC 1094kW/6.55COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane RTHC 1094kW/6.55COP/Valve,  !- Name
    1093600,                 !- Reference Capacity {W}
    6.55,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    23.33,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.04921,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04524,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane RTHC 1094kW/6.55COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 1094kW/6.55COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane RTHC 1094kW/6.55COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.25,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.25,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_1108kW_6_92COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1107700,
      COP_nominal =         6.92,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.0571,
      mCon_flow_nominal =   1000 * 0.05142,
      TEvaLvg_nominal =     273.15 + 8.97,
      TConEnt_nominal =     273.15 + 23.74,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {6.631328E-01,-1.027433E-02,-5.388040E-04,3.320295E-02,-1.304714E-03,2.169498E-03},
      EIRFunT =             {5.668296E-01,-2.800906E-02,9.362408E-04,2.210818E-02,4.660373E-04,-7.989601E-04},
      EIRFunPLR =           {1.370745E-01,8.374817E-01,2.534280E-02},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 1108kW/6.92COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 1108kW/6.92COP/Valve,  !- Name
    1107700,                 !- Reference Capacity {W}
    6.92,                    !- Reference COP {W/W}
    8.97,                    !- Reference Leaving Chilled Water Temperature {C}
    23.74,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.0571,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.05142,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 1108kW/6.92COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 1108kW/6.92COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 1108kW/6.92COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YS_1171kW_9_15COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1171000,
      COP_nominal =         9.15,
      PLRMin =              0.09,
      PLRMinUnl =           0.09,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.03249,
      mCon_flow_nominal =   1000 * 0.05173,
      TEvaLvg_nominal =     273.15 + 6.11,
      TConEnt_nominal =     273.15 + 15.56,
      TEvaLvgMin =          273.15 + 6.11,
      TEvaLvgMax =          273.15 + 12.78,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {9.299045E-01,2.350383E-02,-4.649409E-04,-4.367237E-03,-2.040112E-04,6.430038E-04},
      EIRFunT =             {5.325834E-01,-2.611733E-02,1.365012E-03,4.099324E-02,3.401995E-04,-1.514251E-03},
      EIRFunPLR =           {1.889392E-01,4.684305E-01,3.451545E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YS 1171kW/9.15COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YS 1171kW/9.15COP/Valve,  !- Name
    1171000,                 !- Reference Capacity {W}
    9.15,                    !- Reference COP {W/W}
    6.11,                    !- Reference Leaving Chilled Water Temperature {C}
    15.56,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03249,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.05173,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YS 1171kW/9.15COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YS 1171kW/9.15COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YS 1171kW/9.15COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.09,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.09,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Carrier_23XL_1196kW_6_39COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1195600,
      COP_nominal =         6.39,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.03,
      mEva_flow_nominal =   1000 * 0.03653,
      mCon_flow_nominal =   1000 * 0.04271,
      TEvaLvg_nominal =     273.15 + 7.22,
      TConEnt_nominal =     273.15 + 23.89,
      TEvaLvgMin =          273.15 + 6.67,
      TEvaLvgMax =          273.15 + 12.22,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 23.89,
      capFunT =             {5.775948E-01,2.206074E-02,-3.342365E-03,3.970188E-02,-1.669877E-03,2.762827E-03},
      EIRFunT =             {5.077824E-01,-1.608447E-02,1.742121E-04,2.093857E-02,4.160938E-04,-7.169668E-04},
      EIRFunPLR =           {1.061065E-01,7.305514E-01,1.632883E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Carrier 23XL 1196kW/6.39COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Carrier 23XL 1196kW/6.39COP/Valve,  !- Name
    1195600,                 !- Reference Capacity {W}
    6.39,                    !- Reference COP {W/W}
    7.22,                    !- Reference Leaving Chilled Water Temperature {C}
    23.89,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.03653,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.04271,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Carrier 23XL 1196kW/6.39COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 1196kW/6.39COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Carrier 23XL 1196kW/6.39COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.03,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YS_1554kW_9_31COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1554300,
      COP_nominal =         9.31,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.02,
      mEva_flow_nominal =   1000 * 0.0424,
      mCon_flow_nominal =   1000 * 0.07949,
      TEvaLvg_nominal =     273.15 + 5.56,
      TConEnt_nominal =     273.15 + 15.56,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 15.56,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {1.083027E+00,9.278069E-03,1.175024E-03,-1.395851E-02,9.301303E-05,6.968115E-05},
      EIRFunT =             {5.099117E-01,1.379553E-02,-2.069529E-04,2.846021E-02,7.189977E-04,-2.027317E-03},
      EIRFunPLR =           {1.720219E-01,5.084848E-01,3.212462E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YS 1554kW/9.31COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YS 1554kW/9.31COP/Valve,  !- Name
    1554300,                 !- Reference Capacity {W}
    9.31,                    !- Reference COP {W/W}
    5.56,                    !- Reference Leaving Chilled Water Temperature {C}
    15.56,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.0424,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.07949,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YS 1554kW/9.31COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YS 1554kW/9.31COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YS 1554kW/9.31COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.02,                    !- Maximum Part Load Ratio
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

  record ElectricEIRChiller_York_YS_1758kW_5_84COP_Valve =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -1758300,
      COP_nominal =         5.84,
      PLRMin =              0.20,
      PLRMinUnl =           0.20,
      PLRMax =              1.04,
      mEva_flow_nominal =   1000 * 0.07571,
      mCon_flow_nominal =   1000 * 0.09464,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 8.89,
      TConEntMin =          273.15 + 12.78,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {8.130185E-01,-1.425368E-02,-1.618007E-03,2.638417E-02,-9.154379E-04,1.696015E-03},
      EIRFunT =             {6.381264E-01,6.304193E-03,9.233511E-04,-4.552881E-03,8.256904E-04,-1.561533E-03},
      EIRFunPLR =           {3.149879E-01,3.171267E-01,3.709077E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller York YS 1758kW/5.84COP/Valve" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YS 1758kW/5.84COP/Valve,  !- Name
    1758300,                 !- Reference Capacity {W}
    5.84,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.07571,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.09464,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller York YS 1758kW/5.84COP/Valve CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YS 1758kW/5.84COP/Valve EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YS 1758kW/5.84COP/Valve EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.20,                    !- Minimum Part Load Ratio
    1.04,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.20,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_Trane_CGWD_207kW_3_99COP_None =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -207400,
      COP_nominal =         3.99,
      PLRMin =              0.25,
      PLRMinUnl =           0.25,
      PLRMax =              1.01,
      mEva_flow_nominal =   1000 * 0.00898,
      mCon_flow_nominal =   1000 * 0.01122,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 29.44,
      TEvaLvgMin =          273.15 + 5.56,
      TEvaLvgMax =          273.15 + 10.00,
      TConEntMin =          273.15 + 23.89,
      TConEntMax =          273.15 + 35.00,
      capFunT =             {9.441897E-01,3.371079E-02,9.756685E-05,-3.220573E-03,-4.917369E-05,-1.775717E-04},
      EIRFunT =             {7.273870E-01,-1.189276E-02,5.411677E-04,1.879294E-03,4.734664E-04,-7.114850E-04},
      EIRFunPLR =           {4.146742E-02,6.543795E-01,3.044125E-01},
      etaMotor =            1.0)
    "ElectricEIRChiller Trane CGWD 207kW/3.99COP/None" annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller Trane CGWD 207kW/3.99COP/None,  !- Name
    207400,                  !- Reference Capacity {W}
    3.99,                    !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    29.44,                   !- Reference Entering Condenser Fluid Temperature {C}
    0.00898,                 !- Reference Chilled Water Flow Rate {m3/s}
    0.01122,                 !- Reference Condenser Water Flow Rate {m3/s}
    ElectricEIRChiller Trane CGWD 207kW/3.99COP/None CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller Trane CGWD 207kW/3.99COP/None EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller Trane CGWD 207kW/3.99COP/None EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.25,                    !- Minimum Part Load Ratio
    1.01,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.25,                    !- Minimum Unloading Ratio
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

  record ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled =
    Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
      QEva_flow_nominal =  -100582,
      COP_nominal =         3.1,
      PLRMin =              0.10,
      PLRMinUnl =           0.10,
      PLRMax =              1.15,
      mEva_flow_nominal =   1000 * 0.0043,
      mCon_flow_nominal =   1.2 * 9.4389,
      TEvaLvg_nominal =     273.15 + 6.67,
      TConEnt_nominal =     273.15 + 35,
      TEvaLvgMin =          273.15 + 4.44,
      TEvaLvgMax =          273.15 + 10.0,
      TConEntMin =          273.15 + 23.89,
      TConEntMax =          273.15 + 51.67,
      capFunT =             {-0.2660645697,0.0998714035,-0.0023814154,0.0628316481,-0.0009644649,-0.0011249224},
      EIRFunT =             {0.1807017787,0.0271530312,-0.0004553574,0.0188175079,0.0002623276,-0.0012881189},
      EIRFunPLR =           {0.0,1.0,0.0},
      etaMotor =            1.0)
    "ElectricEIRChiller York YCAL0033EE 100.6 kW/3.1 COP Air Cooled"
                                                        annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
<pre>
Chiller:Electric:EIR,
    ElectricEIRChiller York YCAL0033EE 100.6kW/3.1COP,  !- Name
    100582,                  !- Reference Capacity {W}
    3.1,                     !- Reference COP {W/W}
    6.67,                    !- Reference Leaving Chilled Water Temperature {C}
    35,                      !- Reference Entering Condenser Fluid Temperature {C}
    0.0043,                  !- Reference Chilled Water Flow Rate {m3/s}
    0.0011,                  !- Reference Condenser Fluid Flow Rate {m3/s}
    ElectricEIRChiller York YCAL0033EE 100.6kW/3.1COP CAPFT,  !- Cooling Capacity Function of Temperature Curve Name
    ElectricEIRChiller York YCAL0033EE 100.6kW/3.1COP EIRFT,  !- Electric Input to Cooling Output Ratio Function of Temperature Curve Name
    ElectricEIRChiller York YCAL0033EE 100.6kW/3.1COP EIRFPLR,  !- Electric Input to Cooling Output Ratio Function of Part Load Ratio Curve Name
    0.10,                    !- Minimum Part Load Ratio
    1.15,                    !- Maximum Part Load Ratio
    1.0,                     !- Optimum Part Load Ratio
    0.10,                    !- Minimum Unloading Ratio
    Chilled Water Side Inlet Node,  !- Chilled Water Inlet Node Name
    Chilled Water Side Outlet Node,  !- Chilled Water Outlet Node Name
    Condenser Side Inlet Node,  !- Condenser Inlet Node Name
    Condenser Side Outlet Node,  !- Condenser Outlet Node Name
    AirCooled,               !- Condenser Type
    ,                        !- Condenser Fan Power Ratio {W/W}
    1.0,                     !- Fraction of Compressor Electric Consumption Rejected by Condenser
    2.0,                     !- Leaving Chilled Water Lower Temperature Limit {C}
    ConstantFlow,            !- Chiller Flow Mode
    0.0;                     !- Design Heat Recovery Water Flow Rate {m3/s}
</pre>
<br>
Note that the reference condenser fluid volumetric flow rate listed in the
EnergyPlus performance data is not reasonable.  The value obtained
from the manufacturer data sheet is used instead.  The data sheet
is available
<a href=\"https://www.johnsoncontrols.com/en_hk/-/media/jci/be/united-states/hvac-equipment/chillers/files/be_eng_guide_-ycal_scroll-chillers-style-e-50-and-60-hz-111417.pdf\">here</a>
.  Please see the Section for Physical Data and Nominal Ratings and row for Condender Fans Total Chiller CFM.
</html>"));
annotation(preferredView="info",
 Documentation(info="<html>
<p>
Package with performance data for chillers.
</p>
</html>", revisions="<html>
<ul>
<li>
November 19, 2021 by David Blum:<br/>
Added air-cooled chiller YCAL0033EE.
</li>
<li>
April 25, 2016 by Thierry Nouidui:<br/>
Generated.
</li>
</ul>
</html>"));
end ElectricEIR;
