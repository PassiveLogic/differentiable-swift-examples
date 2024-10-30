# Differentiable Simulator Benchmarks

[PassiveLogic](https://passivelogic.com) is constructing autonomous systems for building control and
more, utilizing physics-based digital twins. As a motivating use case for differentiable Swift, a
simple thermal model of a building was constructed and optimized via gradient descent in several
languages and frameworks.

Differentiable Swift proves to be the best of the available solutions, and that has driven
PassiveLogic's investment in the language feature. This directory contains a representative benchmark
for a thermal model of a building implemented in differentiable Swift,
[PyTorch](https://pytorch.org), and [TensorFlow](https://www.tensorflow.org).

In this benchmark, the average time for a full forward + backward pass through the simulation is 
measured across multiple trials. The lower the time, the better.

## Running Benchmarks

To evaluate the benchmarks yourself, the following sections provide setup instructions for the
environments needed for each language / framework. These instructions should be valid for macOS and
Ubuntu 20.04, but may require slight modification for other platforms.

### Swift

A Swift toolchain with support for differentiation must be installed and in your current path. We 
recommend using one [downloaded from Swift.org](https://www.swift.org/download/) for your platform. 
Nightly toolchain snapshots tend to have better performance, due to new optimizations and 
architectural improvements constantly being upstreamed. More information on toolchain installation 
and management can be found [here](https://passivelogic.github.io/differentiable-swift-examples/documentation/differentiableswiftexamples/setup).

When using a recent Swift.org nightly toolchain snapshot on macOS, you may need to set the following environment variables to point to the correct macOS SDK and Swift runtime:
```bash
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.sdk
```
```bash
export DYLD_LIBRARY_PATH=/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2023-11-20-a.xctoolchain/usr/lib/swift/macosx
```

To build the benchmark, change into the `Swift` subdirectory and run the following:
```bash
swiftc -O main.swift -o SwiftBenchmark
```

and then run it via:
```bash
./SwiftBenchmark
```

### PyTorch

For these benchmarks, we've used PyTorch on the CPU, running in a dedicated Python environment. If
you have such an environment, you can activate it and jump ahead to running the benchmark. To
set up such an environment, start in your home directory and type:

```bash
python3 -m venv pytorch-cpu
source pytorch-cpu/bin/activate
pip install torch torchvision
```

and then run the benchmark by going to the `PyTorch` subdirectory here and using:

```bash
python3 PyTorchSimulator.py
```

### TensorFlow

For these benchmarks, we've used TensorFlow on the CPU, running in a dedicated Python environment. If
you have such an environment, you can activate it and jump ahead to running the benchmark. To
set up such an environment, start in your home directory and type:

```bash
python3 -m venv tensorflow-cpu
source tensorflow-cpu/bin/activate
pip install tensorflow
```

and then run the benchmark by going to the `TensorFlow` subdirectory here and using:

```bash
python3 TensorFlowSimulator.py
```

### Haskell

For this benchmark we used the GHC Haskell compiler executing on the CPU. If you
have a Haskell environment set up already you can jump ahead to running the
benchmark. To set up such an environment I recommend to use the GHCup tool which
can be found [here](https://www.haskell.org/ghcup/).

Once that is installed and in your path you can either use the interactive mode
to select and install the version you want with:

```bash
ghcup tui
```

and follow the on-screen instructions, or simply:

```bash
ghcup install ghc
ghcup install cabal
```

and it will install the currently recommended version for you.

Once you have both the compiler `ghc` and the package manager `cabal` installed,
you can run the benchmark by going to the `Haskell` subdirectory and using the
command:

```bash
cabal run
```


## Current Results

### 2024-07-30

Various optimizations in Differentiable Swift landed in the nightly toolchain dated 2024-06-03. The following benchmarks were run primarily to measure the effect of those optimizations. This optimized version of Differentiable Swift was compared to PyTorch and TensorFlow, as well as the most recent toolchain _without_ these optimizations, which resolved to the nightly toolchain dated 2024-05-15.

In addition to Forward Only and Gradient measurements, Memory Utilization and Power Consumption were also recorded for comparison. The dimensions of each simulation were scaled from 100 to 100,000 in both number of `trials` and `timesteps`.

Note that 'Swift Improvement' in the tables below is calculated by dividing each measurement by the corresponding measurement from the optimized Swift column. In other words, a 'Swift Improvement' of 5.2 translates to a measurement being 5.2x longer/larger/more than optimized Swift's measurement.

#### Environment Setup
Forward Only/Gradient and Memory Utilization results were gathered from the same hardware, with the following specs:
 - Model: MacBook Pro, 2021
 - CPU: Apple M1 Max
 - Memory: 32 GB
 - OS: Sonoma 14.5

Power consumption results were gathered from Jetson Orin NX hardware:
 - Model: Jetson Orin NX 16GB
 - CPU: 8-core Arm® Cortex®-A78AE v8.2 64-bit CPU 2MB L2 + 4MB L3
 - Memory: 16 GB
 - OS: Ubuntu 20.04.6 LTS

#### Forward Only and Gradient times
Results were recorded from each script's execution output. Example Swift output:
```
$ ./SwiftBenchmark
trials: 1000
timesteps: 1000
average forward only time: 2.1570954999999886e-05 seconds
average forward and back (gradient) time: 0.0002565037070000004 seconds
```

---
##### Forward only time

<table><thead>
  <tr>
    <th>N trials<br>timesteps=20<br>warmup=3</th>
    <th>Swift nightly toolchain 2024-06-03</th>
    <th>Swift nightly toolchain 2024-05-15</th>
    <th>Swift Improvement</th>
    <th>PyTorch 2.3.1</th>
    <th>Swift Improvement</th>
    <th>TensorFlow 2.16.2</th>
    <th>Swift Improvement</th>
  </tr></thead>
<tbody>
  <tr>
    <td>100</td>
    <td>1.0133E-06</td>
    <td>1.30496E-06</td>
    <td>1.3</td>
    <td>0.00237510204315186</td>
    <td>2,344</td>
    <td>0.000805909633636475</td>
    <td>795</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>9.86573000000009E-07</td>
    <td>6.88607999999986E-07</td>
    <td>0.7</td>
    <td>0.00232325196266174</td>
    <td>2,355</td>
    <td>0.00071248984336853</td>
    <td>722</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>5.82377500000031E-07</td>
    <td>4.38613799999972E-07</td>
    <td>0.8</td>
    <td>0.00217494251728058</td>
    <td>3,735</td>
    <td>0.000711746025085449</td>
    <td>1222</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>4.26006110000326E-07</td>
    <td>4.15276820000269E-07</td>
    <td>1.0</td>
    <td>0.00216188388347626</td>
    <td>5,075</td>
    <td>0.000706250309944153</td>
    <td>1658</td>
  </tr>
  <tr>
    <td>N timesteps<br>trials=1<br>warmup=3</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100</td>
    <td>2.708E-06</td>
    <td>1.5333E-05</td>
    <td>5.7</td>
    <td>0.0117650032043457</td>
    <td>4344</td>
    <td>0.0032660961151123</td>
    <td>1206</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>2.6625E-05</td>
    <td>3.9333E-05</td>
    <td>1.5</td>
    <td>0.134914875030518</td>
    <td>5067</td>
    <td>0.0305349826812744</td>
    <td>1146</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>0.0002945</td>
    <td>0.000286833</td>
    <td>1.0</td>
    <td>1.36807107925415</td>
    <td>4645</td>
    <td>0.283676862716675</td>
    <td>963</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>0.002944209</td>
    <td>0.002668</td>
    <td>0.9</td>
    <td>14.5915961265564</td>
    <td>4956</td>
    <td>2.96268224716187</td>
    <td>1006</td>
  </tr>
</tbody></table>

---

##### Gradient time

<table><thead>
  <tr>
    <th>N trials<br>timesteps=20<br>warmup=3</th>
    <th>Swift nightly toolchain 2024-06-03</th>
    <th>Swift nightly toolchain 2024-05-15</th>
    <th>Swift Improvement</th>
    <th>PyTorch 2.3.1</th>
    <th>Swift Improvement</th>
    <th>TensorFlow 2.16.2</th>
    <th>Swift Improvement</th>
  </tr></thead>
<tbody>
  <tr>
    <td>100</td>
    <td>1.15975E-05</td>
    <td>7.078584E-05</td>
    <td>6.1</td>
    <td>0.00431931495666504</td>
    <td>372</td>
    <td>0.00388913154602051</td>
    <td>335</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>1.0679188E-05</td>
    <td>4.90754170000001E-05</td>
    <td>4.6</td>
    <td>0.00436905145645142</td>
    <td>409</td>
    <td>0.00370328974723816</td>
    <td>347</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>6.28462230000005E-06</td>
    <td>3.25445147000002E-05</td>
    <td>5.2</td>
    <td>0.00417288513183594</td>
    <td>664</td>
    <td>0.00359320862293243</td>
    <td>572</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>4.59303872000145E-06</td>
    <td>3.11354585500016E-05</td>
    <td>6.8</td>
    <td>0.0042010071516037</td>
    <td>915</td>
    <td>0.00364944223880768</td>
    <td>795</td>
  </tr>
  <tr>
    <td>N timesteps<br>trials=1<br>warmup=3</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100</td>
    <td>4.8334E-05</td>
    <td>0.000240042</td>
    <td>5.0</td>
    <td>0.0222558975219727</td>
    <td>460</td>
    <td>0.0169031620025635</td>
    <td>349</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>0.000373375</td>
    <td>0.002190209</td>
    <td>5.9</td>
    <td>0.242650985717773</td>
    <td>649</td>
    <td>0.169112920761108</td>
    <td>452</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>0.003654458</td>
    <td>0.021470334</td>
    <td>5.9</td>
    <td>2.81965517997742</td>
    <td>771</td>
    <td>48.2916069030762</td>
    <td>13214*</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>0.0372425</td>
    <td>0.179142666</td>
    <td>4.8</td>
    <td>36.6493611335754</td>
    <td>984</td>
    <td>983.002796888351</td>
    <td>26394*</td>
  </tr>
</tbody></table>

\* \- Two recommended performance improvements were adopted in TensorFlowSimulator.py before running benchmarks. The first was to decorate `getGradient` with `@tf.function` to disable default eager execution, which generally increased performance. The second was to use `tf.range` instead of Python's `range` function, in order to avoid 'Large unrolled loop' warnings. This greatly reduced overall memory usage, but seemed to trigger a severe increase in gradient times in high-timestep cases (10k and 100k). Underlying cause has not yet been identified.

---
#### Memory Utilization
For memory utilization, the `time` utility was used to measure 'maximum resident set size' and 'peak memory footprint'.
Example output:
```
/usr/bin/time -l ./SwiftBenchmark
trials: 1000
timesteps: 1000
average forward only time: 2.138608299999987e-05 seconds
average forward and back (gradient) time: 0.00025673441800000017 seconds
0.28 real 0.26 user 0.02 sys
5029888  maximum resident set size
0  average shared memory size
0  average unshared data size
0  average unshared stack size
455  page reclaims
1  page faults
0  swaps
0  block input operations
0  block output operations
0  messages sent
0  messages received
0  signals received
0  voluntary context switches
22  involuntary context switches
3567193705  instructions retired
854329255  cycles elapsed
3278336  peak memory footprint
```

---
##### Maximum resident set size
<table><thead>
  <tr>
    <th>N trials<br>timesteps=20<br>warmup=3</th>
    <th>Swift nightly toolchain 2024-06-03</th>
    <th>Swift nightly toolchain 2024-05-15</th>
    <th>Swift Improvement</th>
    <th>PyTorch 2.3.1</th>
    <th>Swift Improvement</th>
    <th>TensorFlow 2.16.2</th>
    <th>Swift Improvement</th>
  </tr></thead>
<tbody>
  <tr>
    <td>100</td>
    <td>3899392</td>
    <td>3391488</td>
    <td>0.9</td>
    <td>198754304</td>
    <td>51</td>
    <td>433504256</td>
    <td>111</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>3391488</td>
    <td>3751936</td>
    <td>1.1</td>
    <td>196542464</td>
    <td>58</td>
    <td>430637056</td>
    <td>127</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>3604480</td>
    <td>3751936</td>
    <td>1.0</td>
    <td>199507968</td>
    <td>55</td>
    <td>433668096</td>
    <td>120</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>3538944</td>
    <td>3915776</td>
    <td>1.1</td>
    <td>201326592</td>
    <td>57</td>
    <td>437469184</td>
    <td>124</td>
  </tr>
  <tr>
    <td>N timesteps<br>trials=1<br>warmup=3</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100</td>
    <td>3375104</td>
    <td>3866624</td>
    <td>1.1</td>
    <td>205455360</td>
    <td>60</td>
    <td>428326912</td>
    <td>126</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>3866624</td>
    <td>5537792</td>
    <td>1.4</td>
    <td>379322368</td>
    <td>98</td>
    <td>426360832</td>
    <td>110</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>8421376</td>
    <td>24870912</td>
    <td>3.0</td>
    <td>2404892672</td>
    <td>285</td>
    <td>609255424</td>
    <td>72</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>55050240</td>
    <td>220332032</td>
    <td>4.0</td>
    <td>10271408128</td>
    <td>186</td>
    <td>1661583360</td>
    <td>30</td>
  </tr>
</tbody></table>

---
##### Peak memory footprint
<table><thead>
  <tr>
    <th>N trials<br>timesteps=20<br>warmup=3</th>
    <th>Swift nightly toolchain 2024-06-03</th>
    <th>Swift nightly toolchain 2024-05-15</th>
    <th>Swift Improvement</th>
    <th>PyTorch 2.3.1</th>
    <th>Swift Improvement</th>
    <th>TensorFlow 2.16.2</th>
    <th>Swift Improvement</th>
  </tr></thead>
<tbody>
  <tr>
    <td>100</td>
    <td>2458816</td>
    <td>1901696</td>
    <td>0.8</td>
    <td>133400896</td>
    <td>54</td>
    <td>239210560</td>
    <td>97</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>1950912</td>
    <td>2294976</td>
    <td>1.2</td>
    <td>132860352</td>
    <td>68</td>
    <td>236031808</td>
    <td>121</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>2163904</td>
    <td>2278656</td>
    <td>1.1</td>
    <td>133253440</td>
    <td>62</td>
    <td>236719872</td>
    <td>109</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>2098368</td>
    <td>2409728</td>
    <td>1.1</td>
    <td>134318336</td>
    <td>64</td>
    <td>240111552</td>
    <td>114</td>
  </tr>
  <tr>
    <td>N timesteps<br>trials=1<br>warmup=3</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>100</td>
    <td>1934528</td>
    <td>2393280</td>
    <td>1.2</td>
    <td>143346176</td>
    <td>74</td>
    <td>238309248</td>
    <td>123</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>2393280</td>
    <td>4064448</td>
    <td>1.7</td>
    <td>292129920</td>
    <td>122</td>
    <td>239030080</td>
    <td>99</td>
  </tr>
  <tr>
    <td>10000</td>
    <td>6964480</td>
    <td>23430464</td>
    <td>3.4</td>
    <td>1819930944</td>
    <td>261</td>
    <td>293621952</td>
    <td>42</td>
  </tr>
  <tr>
    <td>100000</td>
    <td>48531072</td>
    <td>214257152</td>
    <td>4.4</td>
    <td>17550355200</td>
    <td>361</td>
    <td>806886848</td>
    <td>16</td>
  </tr>
</tbody></table>

---
#### Power Consumption
In order to measure the energy consumed during program execution we employed the use of a current shunt, a differential probe, and an oscilloscope.

The current shunt resistor was placed in series with the positive input power terminal on the Orin. Both the voltage and current consumed were captured at high speed using 2 channels on an oscilloscope.

The capture length of the oscilloscope trace is 1.2 seconds. Due to the fact that 3 of the 4 tests are too long to be fully captured, we measured the total time that each test took and used the oscilloscope measurements to determine the average power consumed during the test for each program. We then extrapolated the total power consumed by each program by multiplying the average power level by the length of the test in seconds.

The overall number of compute operations was calculated by multiplying the number of trials (5000) by number of timesteps (1000) by each program's number of mathematical operations that occur in each timestep (37 for Swift, 49 for TensorFlow/PyTorch). It is worth noting that some calculations required extra steps to work with compatible tensor shapes (for example, compare the `updateQuanta` function in each program). While we do factor this into our results, it highlights the difference in using automatic differentation to operate on heterogeneous neural networks as opposed to conforming to shape-defined tensors.

The following results show a few different views of energy consumption -- Operations computed per kiloJoule consumed, and Joules consumed per giga-Operation (J/GOps).

##### Power consumption of a 5000-trial 1000-timestep simulation
<table><thead>
  <tr>
    <th></th>
    <th>Test Power (avg W)</th>
    <th>Test Length (s)</th>
    <th>Total Energy (J)</th>
    <th>Normalized Ratio</th>
    <th>Ops / kiloJoule</th>
    <th>Joules / GigaOp</th>
  </tr></thead>
<tbody>
  <tr>
    <td>Swift nightly toolchain 2024-05-15</td>
    <td>10.37</td>
    <td>3.828</td>
    <td>39.70</td>
    <td>6</td>
    <td>4,660</td>
    <td>215</td>
  </tr>
  <tr>
    <td>Swift nightly toolchain 2024-06-03</td>
    <td>10.20</td>
    <td>0.616</td>
    <td>6.28</td>
    <td>1</td>
    <td>29,452</td>
    <td>34</td>
  </tr>
  <tr>
    <td>Tensorflow</td>
    <td>12.54</td>
    <td>658.846</td>
    <td>8259.66</td>
    <td>1315</td>
    <td>30</td>
    <td>33713</td>
  </tr>
  <tr>
    <td>PyTorch</td>
    <td>12.34</td>
    <td>3340.826</td>
    <td>41220.14</td>
    <td>6562</td>
    <td>6</td>
    <td>168245</td>
  </tr>
</tbody>
</table>

---

## Previous Results
### 2023-12-10
The following timings were gathered using these benchmarks on an M1 Pro MacBook Pro (14", 2021):

| **Version** | **Time (ms)** | **Slowdown Compared to Swift** |
|---|:---:|:---:|
| **Swift** | 0.03 | 1X |
| **PyTorch** | 8.16 | 238X |
| **TensorFlow** | 11.0 | 322X |
