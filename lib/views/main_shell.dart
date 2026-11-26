import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/theme_controller.dart';
import '../services/auto_update_checker.dart';
import 'dashboard_page.dart';
import 'expense_form_page.dart';
import 'history_page.dart';
import 'recap_page.dart';
import 'records_page.dart';
import 'theme/app_theme.dart';
import 'widgets/glass.dart';
import 'widgets/update_dialog.dart';

/// Kerangka utama: latar gradasi, judul besar, drawer menu, dan navigasi bawah
/// berupa ikon (Home / Pencatatan) dengan tombol "+" di tengah.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _menu = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  late final Animation<double> _menuProgress = CurvedAnimation(
    parent: _menu,
    curve: Curves.easeInOutCubic,
  );

  int _index = 0;

  static const _titles = ['Dashboard', 'Pencatatan'];
  static const _tabs = [
    _NavTab('Home', Icons.home_outlined, Icons.home_rounded),
    _NavTab(
        'Pencatatan', Icons.receipt_long_outlined, Icons.receipt_long_rounded),
  ];
  static const _pages = [DashboardPage(), RecordsPage()];

  @override
  void initState() {
    super.initState();
    // Cek update otomatis setelah layar pertama tampil.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AutoUpdateChecker.run(context);
    });
  }

  @override
  void dispose() {
    _menu.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    final scaffold = _scaffoldKey.currentState!;
    if (scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    } else {
      // Mulai animasi ikon langsung saat ditekan agar terasa responsif.
      _menu.forward();
      scaffold.openDrawer();
    }
  }

  void _select(int i) {
    if (i != _index) setState(() => _index = i);
  }

  void _onDrawerSelect(int i) {
    _scaffoldKey.currentState!.closeDrawer();
    if (i < _pages.length) {
      _select(i);
    } else if (i == _pages.length) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const HistoryPage()),
      );
    } else if (i == _pages.length + 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RecapPage()),
      );
    } else {
      showUpdateDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final text = Theme.of(context).textTheme;

    return PopScope(
      // Tombol back di tab Pencatatan kembali ke Dashboard dulu.
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _select(0);
      },
      child: AppBackground(
        ambient: true,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          extendBody: true,
          onDrawerChanged: (open) => open ? _menu.forward() : _menu.reverse(),
          appBar: AppBar(
            toolbarHeight: 72,
            leading: IconButton(
              tooltip: 'Menu',
              onPressed: _toggleDrawer,
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _menuProgress,
              ),
            ),
            titleSpacing: 4,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                _titles[_index],
                key: ValueKey(_index),
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            actions: [
              GlassIconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Mode terang' : 'Mode gelap',
                onPressed: () =>
                    context.read<ThemeController>().toggle(brightness),
              ),
              const SizedBox(width: 12),
            ],
          ),
          drawer: NavigationDrawer(
            selectedIndex: _index,
            onDestinationSelected: _onDrawerSelect,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
                child: Text(
                  'Catatan Pengeluaran',
                  style:
                      text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const NavigationDrawerDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              const NavigationDrawerDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: Text('Pencatatan'),
              ),
              const NavigationDrawerDestination(
                icon: Icon(Icons.history),
                label: Text('Riwayat'),
              ),
              const NavigationDrawerDestination(
                icon: Icon(Icons.calendar_view_month_outlined),
                selectedIcon: Icon(Icons.calendar_view_month),
                label: Text('Rekap Bulanan'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: Divider(),
              ),
              const NavigationDrawerDestination(
                icon: Icon(Icons.system_update_outlined),
                selectedIcon: Icon(Icons.system_update),
                label: Text('Cek Update'),
              ),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey(_index), child: _pages[_index]),
          ),
          bottomNavigationBar: _IconNavBar(
            tabs: _tabs,
            selected: _index,
            onSelect: _select,
            onAdd: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ExpenseFormPage()),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab(this.label, this.icon, this.selectedIcon);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

// Ukuran bottom bar bertakik (lihat _NotchedBarPainter).
const double _barHeight = 72;
const double _barDip = 10; // turunan tepi atas dari sudut ke tengah
const double _notchRadius = 40;
const double _buttonRadius = 30;
const double _buttonLift = 30; // tinggi tombol yang menonjol di atas bar

/// Navigasi bawah: bar melayang dengan takik melengkung di tengah, tombol
/// "+" bulat di takik, ikon Home (kiri) dan Pencatatan (kanan).
class _IconNavBar extends StatelessWidget {
  const _IconNavBar({
    required this.tabs,
    required this.selected,
    required this.onSelect,
    required this.onAdd,
  });

  final List<_NavTab> tabs;
  final int selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Nada kartu kaca di atas latar, dibuat opak agar konten tidak tembus.
    final barColor = Color.alphaBlend(p.glass, p.bgBottom);

    Widget tab(int i) => Expanded(
          child: _NavIcon(
            tab: tabs[i],
            active: i == selected,
            onTap: () => onSelect(i),
          ),
        );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: SizedBox(
          height: _barHeight + _buttonLift,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                top: _buttonLift,
                child: CustomPaint(
                  painter: _NotchedBarPainter(
                    color: barColor,
                    border: p.glassBorder,
                    shadow: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: _barDip),
                    child: Row(
                      children: [
                        tab(0),
                        const SizedBox(width: _notchRadius * 2 + 24),
                        tab(1),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: _buttonLift + _notchCenterY - _buttonRadius,
                left: 0,
                right: 0,
                child: Center(child: _AddButton(onPressed: onAdd)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ujung lengkung takik: [_notchEdgeInset] ke dalam dari radius takik dan
/// [_notchEdgeDrop] di bawah garis [_barDip].
const double _notchEdgeInset = 2;
const double _notchEdgeDrop = 8;

/// Posisi y pusat lingkaran takik, relatif ke tepi atas bar.
final double _notchCenterY = _barDip +
    _notchEdgeDrop -
    math.sqrt(_notchRadius * _notchRadius -
        (_notchRadius - _notchEdgeInset) * (_notchRadius - _notchEdgeInset));

class _NotchedBarPainter extends CustomPainter {
  _NotchedBarPainter({
    required this.color,
    required this.border,
    required this.shadow,
  });

  final Color color;
  final Color border;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const r = 28.0; // radius sudut
    final cx = w / 2;
    const e = _notchRadius - _notchEdgeInset;

    final path = Path()
      ..moveTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..lineTo(cx - _notchRadius - 14, _barDip)
      ..quadraticBezierTo(
          cx - _notchRadius, _barDip, cx - e, _barDip + _notchEdgeDrop)
      ..arcToPoint(
        Offset(cx + e, _barDip + _notchEdgeDrop),
        radius: const Radius.circular(_notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(
          cx + _notchRadius, _barDip, cx + _notchRadius + 14, _barDip)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..lineTo(w, h - r)
      ..quadraticBezierTo(w, h, w - r, h)
      ..lineTo(r, h)
      ..quadraticBezierTo(0, h, 0, h - r)
      ..close();

    canvas.drawShadow(path, shadow, 12, false);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_NotchedBarPainter old) =>
      old.color != color || old.border != border || old.shadow != shadow;
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final _NavTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tab.label,
      child: InkResponse(
        onTap: onTap,
        radius: 30,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              active ? tab.selectedIcon : tab.icon,
              key: ValueKey(active),
              size: 30,
              color: active ? scheme.onSurface : p.muted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol bulat "+" untuk menambah pengeluaran, duduk di takik bar.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    const navy = Color(0xFF17304F);
    return Tooltip(
      message: 'Tambah pengeluaran',
      child: Container(
        width: _buttonRadius * 2,
        height: _buttonRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [p.panelTop, const Color(0xFFE3DDF7)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: const Icon(Icons.add_rounded, color: navy, size: 34),
          ),
        ),
      ),
    );
  }
}
