within Buildings.Fluid.Geothermal.Borefields.Examples;

model BorefieldsTDepRconv
  "Validation model for Darcy-Weisbach pressure drop in borefields"
  extends Buildings.Fluid.Geothermal.Borefields.Examples.Borefields(
    borFieUTubDat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_TDepRConv=true)),
    borFie2UTubParDat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_TDepRConv=true)),
    borFie2UTubSerDat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries,
        use_TDepRConv=true)));
end BorefieldsTDepRconv;
