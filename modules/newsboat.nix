{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ <home-manager/nixos> ];
  home-manager.users.erich =
    { pkgs, ... }:
    {

      programs.newsboat = {
        enable = true;

        urls = [
          # Hacker News
          {
            url = "https://news.ycombinator.com/rss";
            tags = [ "hacker" ];
          }

          # Reddit: Programming
          {
            url = "https://reddit.com/r/rust.rss";
            tags = [
              "reddit"
              "programming"
            ];
          }

          # Reddit: Misc
          {
            url = "https://reddit.com/r/amateurradio.rss";
            tags = [
              "reddit"
              "radio"
            ];
          }

          # Reddit: Computers
          {
            url = "https://reddit.com/r/vintagecomputing.rss";
            tags = [
              "reddit"
              "computers"
            ];
          }
          {
            url = "https://reddit.com/r/retrocomputing.rss";
            tags = [
              "reddit"
              "computers"
            ];
          }
          {
            url = "https://reddit.com/r/homebrewcomputer.rss";
            tags = [
              "reddit"
              "computers"
            ];
          }

          # Blogs
          {
            url = "https://www.righto.com/feeds/posts/default";
            tags = [ "blog" ];
          }
          {
            url = "https://feeds.feedburner.com/TechTinkering";
            tags = [ "blog" ];
          }
          {
            url = "http://feeds.feedburner.com/BigMessOWires";
            tags = [ "blog" ];
          }
          {
            url = "https://blog.wirelessmoves.com/feed";
            tags = [ "blog" ];
          }
          {
            url = "http://www.cocoacrumbs.com/index.xml";
            tags = [ "blog" ];
          }
          {
            url = "https://microcorelabs.wordpress.com/feed";
            tags = [ "blog" ];
          }
          {
            url = "https://cubiclenate.com/feed/";
            tags = [ "blog" ];
          }
          {
            url = "https://longhornengineer.com/feed/";
            tags = [ "blog" ];
          }
          {
            url = "https://blog.heypete.com/feed";
            tags = [ "blog" ];
          }
          {
            url = "https://mike42.me/blog/feed";
            tags = [ "blog" ];
          }
          {
            url = "https://fabiensanglard.net/rss.xml";
            tags = [ "blog" ];
          }
          {
            url = "https://blog.dan.drown.org/rss/";
            tags = [ "blog" ];
          }
          {
            url = "https://computer.rip/rss.xml";
            tags = [ "blog" ];
          }
          {
            url = "https://www.supergoodcode.com/feed.xml";
            tags = [ "blog" ];
          }
          {
            url = "https://sattrackcam.blogspot.com/feeds/posts/default";
            tags = [ "blog" ];
          }
          {
            url = "https://blogs.kde.org/categories/this-week-in-plasma/index.xml";
            tags = [ "blog" ];
          }
          {
            url = "https://utcc.utoronto.ca/~cks/space/blog/?atom";
            tags = [ "blog" ];
          }
          {
            url = "https://chipsandcheese.com/feed";
            tags = [ "blog" ];
          }
          {
            url = "https://skyriddles.wordpress.com/feed";
            tags = [ "blog" ];
          }
          {
            url = "http://www.kroah.com/log/index.rss";
            tags = [ "blog" ];
          }
          {
            url = "https://blog.boscolab.de/?feed=rss2";
            tags = [ "blog" ];
          }
          {
            url = "https://justanotherelectronicsblog.com/";
            tags = [ "blog" ];
          }
          {
            url = "https://xeiaso.net/blog.rss";
            tags = [ "blog" ];
          }

          # Random
          {
            url = "https://www.web3isgoinggreat.com/feed.xml";
            tags = [ "random" ];
          }

          # News
          {
            url = "https://sportscar365.com/feed";
            tags = [ "news" ];
          }
          {
            url = "https://feeds.stripes.com/apps/front_page.xml";
            tags = [ "news" ];
          }
          {
            url = "https://feeds.npr.org/1001/rss.xml";
            tags = [
              "news"
              "npr"
            ];
          }
          {
            url = "https://feeds.npr.org/1007/rss.xml";
            tags = [
              "news"
              "npr"
              "science"
            ];
          }
          {
            url = "https://feeds.npr.org/1019/rss.xml";
            tags = [
              "news"
              "npr"
              "tech"
            ];
          }
          {
            url = "https://feeds.npr.org/1026/rss.xml";
            tags = [
              "news"
              "npr"
              "space"
            ];
          }
          {
            url = "https://universitystar.com/feed";
            tags = [
              "news"
              "txst"
            ];
          }
          {
            url = "https://lwn.net/headlines/rss";
            tags = [
              "news"
              "linux"
            ];
          }

          # Misc
          {
            url = "https://kg5key.com/feed.xml";
            tags = [
              "misc"
              "radio"
            ];
          }
          {
            url = "https://archlinux.org/feeds/news/";
            tags = [
              "misc"
              "linux"
            ];
          }
        ];

        extraConfig = ''
          auto-reload yes
          browser lynx
          show-read-feeds no
          color listnormal cyan default
        '';
      };
    };
}
