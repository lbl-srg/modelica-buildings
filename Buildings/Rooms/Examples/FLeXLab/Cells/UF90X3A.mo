within Buildings.Rooms.Examples.FLeXLab.Cells;
model UF90X3A "Model of user facility test cell 90X3A"
  extends BaseClasses.GenericTestCell(roo(AFlo=A,
      nSurBou=1,
      nConPar=1,
      hRoo=3.6576,
      nConExtWin=1,
      surBou(
        each A=6.645*9.144,
        each absIR=0.9,
        each absSol=0.9,
        each til=Buildings.HeatTransfer.Types.Tilt.Floor),
      datConExt(
        layers={R16p8Wal,R52Wal,R20Wal},
        A={3.6576*4.42,3.6576*1.472, 6.645*9.144},
        til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Ceiling},
        azi={Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.N,Buildings.HeatTransfer.Types.Azimuth.S}),
      datConExtWin(
        layers={R16p8Wal},
        A={6.645*3.6576},
        glaSys={glaSys},
        hWin={1.8288},
        wWin={5.86},
        til={Buildings.HeatTransfer.Types.Tilt.Wall},
        azi={Buildings.HeatTransfer.Types.Azimuth.S}),
      datConPar(
        layers={parCon},
        A={3.6576*1.472},
        til={Buildings.HeatTransfer.Types.Tilt.Wall},
        azi={Buildings.HeatTransfer.Types.Azimuth.S}),
      nConExt=3,
      lat=0.66098585832754,
      intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
      extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind),
                                                   sla(
      disPip=disPip,
      length=A/disPip,
      A=A,
      sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
      pipe=pipe,
      nSeg=10,
      layers=slaCon,
      iLayPip=1),
    watIn(use_m_flow_in=true, use_T_in=true),
    airIn(use_m_flow_in=true, use_T_in=true),
    replicator(nout=max(1, nConExtWin)),
    multiplex3_1(
      n1=1,
      n2=1,
      n3=1));

    //fixme - glaSys model is probably not correct for FLeXLab test cells. See Cindy Regnier 4/16 e-mail for more information

  //Geometry declarations
  parameter Modelica.SIunits.Area A = 60.97 "Floor area of the test cell";
  parameter Modelica.SIunits.Length disPip = 0.2 "Distance between the pipes";

  Data.Constructions.Gyp16Gyp16 parCon
    "Partition wall between the test cell and the electrical room"
    annotation (Placement(transformation(extent={{138,-20},{158,0}})));
  Data.Constructions.Insul24Ply13Insul83Gyp16 R16p8Wal
    "Wall with R16.8 worth of insulation"
    annotation (Placement(transformation(extent={{138,4},{158,24}})));
  HeatTransfer.Data.GlazingSystems.TripleClearAir13ClearAir13Clear glaSys(
      haveExteriorShade=true)
    annotation (Placement(transformation(extent={{136,-92},{156,-72}})));
  Data.Constructions.Insul127Ply13Insul203Ply13Gyp16 R52Wal
    "Wall construction with R52 insulation"
    annotation (Placement(transformation(extent={{138,28},{158,48}})));
  Data.Constructions.Gyp16Insul102Ply13 R20Wal
    "Wall construction with R20 insulation. Used in the roof of test cell UF90X3A"
    annotation (Placement(transformation(extent={{138,56},{158,76}})));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -150},{200,150}}), graphics),
           defaultComponentName="UF90X3A");
end UF90X3A;
