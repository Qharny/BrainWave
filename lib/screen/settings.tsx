// import React, { useState } from 'react';
// import { Moon, Sun, Volume2, VolumeX, Type, Lock, LogOut, Shield, Gauge } from 'lucide-react';
// import { Card, CardContent } from '@/components/ui/card';

// const SettingsScreen = () => {
//   const [darkMode, setDarkMode] = useState(true);
//   const [soundEnabled, setSoundEnabled] = useState(true);
//   const [textSize, setTextSize] = useState(16);
//   const [difficulty, setDifficulty] = useState('Medium');

//   const Section = ({ title, children }) => (
//     <div className="mb-6">
//       <h3 className="text-lg font-semibold mb-3 px-4 text-gray-200">{title}</h3>
//       <Card className="bg-gray-800 border-gray-700">
//         <CardContent className="p-0">
//           {children}
//         </CardContent>
//       </Card>
//     </div>
//   );

//   const SettingItem = ({ icon: Icon, title, children, onClick, border = true }) => (
//     <div 
//       className={`flex items-center justify-between p-4 ${
//         border ? 'border-b border-gray-700' : ''
//       } hover:bg-gray-700 transition-colors`}
//       onClick={onClick}
//     >
//       <div className="flex items-center space-x-3">
//         <Icon className="w-5 h-5 text-blue-400" />
//         <span className="text-gray-200">{title}</span>
//       </div>
//       {children}
//     </div>
//   );

//   const Switch = ({ checked, onChange }) => (
//     <div
//       className={`w-11 h-6 flex items-center rounded-full p-1 cursor-pointer ${
//         checked ? 'bg-blue-500' : 'bg-gray-700'
//       }`}
//       onClick={() => onChange(!checked)}
//     >
//       <div
//         className={`bg-white w-4 h-4 rounded-full transition-transform ${
//           checked ? 'translate-x-5' : 'translate-x-0'
//         }`}
//       />
//     </div>
//   );

//   const Select = ({ value, options, onChange }) => (
//     <select
//       value={value}
//       onChange={(e) => onChange(e.target.value)}
//       className="bg-gray-700 text-gray-200 rounded px-2 py-1 border border-gray-600"
//     >
//       {options.map(option => (
//         <option key={option} value={option}>{option}</option>
//       ))}
//     </select>
//   );

//   return (
//     <div className="min-h-screen bg-gray-900 text-gray-200 p-6">
//       <div className="max-w-2xl mx-auto">
//         <h2 className="text-2xl font-bold mb-6 text-gray-100">Settings</h2>
        
//         <Section title="Appearance">
//           <SettingItem icon={darkMode ? Moon : Sun} title="Dark Mode">
//             <Switch checked={darkMode} onChange={setDarkMode} />
//           </SettingItem>
//           <SettingItem icon={Type} title="Text Size" border={false}>
//             <Select
//               value={textSize}
//               options={[12, 14, 16, 18, 20]}
//               onChange={(val) => setTextSize(Number(val))}
//             />
//           </SettingItem>
//         </Section>

//         <Section title="Sound Settings">
//           <SettingItem 
//             icon={soundEnabled ? Volume2 : VolumeX} 
//             title="Sound Effects" 
//             border={false}
//           >
//             <Switch checked={soundEnabled} onChange={setSoundEnabled} />
//           </SettingItem>
//         </Section>

//         <Section title="Quiz Preferences">
//           <SettingItem icon={Gauge} title="Difficulty" border={false}>
//             <Select
//               value={difficulty}
//               options={['Easy', 'Medium', 'Hard']}
//               onChange={setDifficulty}
//             />
//           </SettingItem>
//         </Section>

//         <Section title="Account">
//           <SettingItem icon={Lock} title="Change Password" />
//           <SettingItem icon={Shield} title="Privacy Settings" />
//           <SettingItem 
//             icon={LogOut} 
//             title="Logout" 
//             border={false}
//             onClick={() => console.log('Logout clicked')}
//           />
//         </Section>
//       </div>
//     </div>
//   );
// };

// export default SettingsScreen;