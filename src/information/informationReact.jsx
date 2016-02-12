// インフォメーションUI
var InformationView;
(function () {
    InformationView = React.createClass({
        show: function () {
            this.refs.result.setState({mode: 'show'});
        },
        render: function () {
            return (
                <div id="information">
                    <Result ref="result" />
                    <Update />
                </div>
            );
        }
    });

    var Result = React.createClass({
        getInitialState: function () {
            return {mode: ''};
        },
        render: function () {
            return (
                <div className={'result ' + this.state.mode}>
                    <p>インフォメーション</p>
                    <div>周辺の情報</div>
                </div>
            );
        }
    });

    var Update = React.createClass({
        update: function () {
            information.update();
        },
        render: function () {
            return (
                <div className="update">
                    <button onClick={this.update.bind(this)}/>
                </div>
            );
        }
    });
})();
