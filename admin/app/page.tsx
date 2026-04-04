import Link from "next/link";

const navItems = [
  { href: "/bookings", label: "Bookings", icon: "📋", desc: "Manage all reservations" },
  { href: "/accommodations", label: "Accommodations", icon: "🏔", desc: "Rooms, cabins, domes" },
  { href: "/passes", label: "Entry Passes", icon: "🎫", desc: "Pass sales & scanning" },
  { href: "/restaurant", label: "Restaurant", icon: "🍽", desc: "Tables & reservations" },
  { href: "/gondola", label: "Gondola", icon: "🚡", desc: "Time slots & capacity" },
  { href: "/tours", label: "Tours", icon: "🥾", desc: "Tours & guides" },
  { href: "/chat-monitor", label: "AI Chat", icon: "🤖", desc: "Monitor AI concierge" },
  { href: "/users", label: "Users", icon: "👥", desc: "User management" },
  { href: "/content/news", label: "Content", icon: "📰", desc: "News, gallery, trails" },
  { href: "/sos", label: "SOS", icon: "🆘", desc: "Emergency alerts" },
  { href: "/analytics", label: "Analytics", icon: "📊", desc: "Revenue & visitors" },
  { href: "/settings", label: "Settings", icon: "⚙️", desc: "Park configuration" },
];

export default function Dashboard() {
  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="bg-[#1B4332] text-white px-8 py-6">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold">Ala-Archa Admin</h1>
            <p className="text-green-200 text-sm">National Park Management</p>
          </div>
          <div className="flex items-center gap-4">
            <div className="text-right">
              <div className="text-sm font-medium">Park Status</div>
              <div className="text-green-300 text-sm font-bold">Open</div>
            </div>
            <div className="w-10 h-10 bg-green-600 rounded-full flex items-center justify-center font-bold">
              A
            </div>
          </div>
        </div>
      </header>

      {/* Stats bar */}
      <div className="bg-white border-b px-8 py-4">
        <div className="max-w-7xl mx-auto grid grid-cols-4 gap-6">
          <StatCard label="Today's Visitors" value="342" change="+12%" />
          <StatCard label="Active Bookings" value="28" change="+5%" />
          <StatCard label="Revenue (today)" value="$4,280" change="+18%" />
          <StatCard label="Occupancy" value="76%" change="+3%" />
        </div>
      </div>

      {/* Navigation Grid */}
      <main className="max-w-7xl mx-auto px-8 py-8">
        <div className="grid grid-cols-3 gap-4 lg:grid-cols-4">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="group flex flex-col items-start p-6 bg-white rounded-xl border border-gray-200 hover:border-[#1B4332] hover:shadow-md transition-all"
            >
              <span className="text-3xl mb-3">{item.icon}</span>
              <span className="font-semibold text-gray-900 group-hover:text-[#1B4332]">
                {item.label}
              </span>
              <span className="text-sm text-gray-500 mt-1">{item.desc}</span>
            </Link>
          ))}
        </div>
      </main>
    </div>
  );
}

function StatCard({
  label,
  value,
  change,
}: {
  label: string;
  value: string;
  change: string;
}) {
  return (
    <div>
      <div className="text-sm text-gray-500">{label}</div>
      <div className="text-2xl font-bold text-gray-900">{value}</div>
      <div className="text-sm text-green-600 font-medium">{change}</div>
    </div>
  );
}
