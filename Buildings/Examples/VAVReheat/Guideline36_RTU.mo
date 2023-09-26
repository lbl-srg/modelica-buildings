within Buildings.Examples.VAVReheat;
model Guideline36_RTU
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.HVACBuilding_RTU(
    mCor_flow_nominal=ACHCor*VRooCor*conv,
    mSou_flow_nominal=ACHSou*VRooSou*conv,
    mEas_flow_nominal=ACHEas*VRooEas*conv,
    mNor_flow_nominal=ACHNor*VRooNor*conv,
    mWes_flow_nominal=ACHWes*VRooWes*conv,
    redeclare Buildings.Examples.VAVReheat.BaseClasses.Guideline36_RTU hvac(
      nCoiCoo=nCoiCoo,
      nCoiHea=nCoiHea,
      datHeaCoi=datHeaCoi,
      datCooCoi=datCooCoi),
    redeclare Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
      sampleModel=true,
      wes(T_start=297.15),
      nor(T_start=297.15),
      cor(T_start=297.15),
      eas(T_start=297.15),
      sou(T_start=297.15)));

  parameter Real ACHCor(final unit="1/h")=6
    "Design air change per hour core";
  parameter Real ACHSou(final unit="1/h")=6
    "Design air change per hour south";
  parameter Real ACHEas(final unit="1/h")=9
    "Design air change per hour east";
  parameter Real ACHNor(final unit="1/h")=6
    "Design air change per hour north";
  parameter Real ACHWes(final unit="1/h")=7
    "Design air change per hour west";
  parameter Integer nCoiHea(min=1) = 6
    "Number of DX heating coils";
  parameter Integer nCoiCoo(min=1) = 6
    "Number of DX cooling coils";
  parameter Real f_num = 0.8
    "Factor to modify cooling capacity of each DX stage ";
  parameter Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil datHeaCoi(
    nSta=1,
    minSpeRat=0.2,
    sta={
      Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=16210.4,
          COP_nominal=3.90494,
          m_flow_nominal=2.01422,
          TEvaIn_nominal=273.15 - 5,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.DXSystems.Heating.AirSource.Examples.PerformanceCurves.Curve_I())},
    defOpe=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostOperation.resistive,
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed,
    tDefRun=1/6,
    TDefLim=273.65,
    QDefResCap=10500,
    QCraCap=200)
    "DX heating coil data record"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  parameter Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCooCoi(
    nSta=5,
    sta={Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
      spe=900/60,
      nomVal=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-12000*f_num,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=0.9),
      perCur=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_I()),
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
      spe=1200/60,
      nomVal=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-18000*f_num,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=1.2),
      perCur=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_I()),
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
      spe=1800/60,
      nomVal=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-21000*f_num,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=1.5),
      perCur=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II()),
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
      spe=2400/60,
      nomVal=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-30000*f_num,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=1.8),
      perCur=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_III()),
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
      spe=3000/60,
      nomVal=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-39000*f_num,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=2.1),
      perCur=
      Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_III())})
    "DX cooling coil data record"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  annotation (
    Documentation(info="<html>
  <p>
  This model replaced an air handler unit (AHU) within a variable air flow (VAV) system,
  as detailed in 
  <a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
  Buildings.Examples.VAVReheat.Guideline36</a>, 
  with a rooftop unit (RTU). 
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  August 28, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36_RTU.mos"
        "Simulate and plot"),
    experiment(
      StartTime=15552000,
      StopTime=18144000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Guideline36_RTU;
